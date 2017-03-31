//
//  Cache.swift
//  CoreiOS
//
//  Created by Albin CR on 12/14/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Cache{
    
    public init(){}
    
    private static let sharedInstance:Cache = Cache()
    
    
    private var _cache:NSCache<AnyObject, AnyObject>?
    
    public static var cache:NSCache<AnyObject, AnyObject>{
        
        get {
            if Cache.sharedInstance._cache == nil{
                Cache.sharedInstance._cache = NSCache()
            }
            return Cache.sharedInstance._cache!
        }
        
    }
    
    //MARK: - Cache data to memCache & disk
    
    //TODO: - pass currect url as key afer adding param
    public class func cacheData(data:Any,key:String,cacheTimeInMinute:Int,cacheType:String,oflineStatus:Bool = false){
        
        let time = NSDate.init()
        
        
        let finalKey = !oflineStatus == false ?("oflineCacheData-\(key)") : ("cacheData-\(key)") 

        var currentTime:String = String(0)
        if cacheTimeInMinute != 0 { currentTime = String(time.timeIntervalSince1970 * 1000) }
        let cacheCreatedTimeKey = currentTime
        let data:[String:Any] = [cacheCreatedTimeKey:data]
        
        if cacheType == Constants.cache.cacheToDiskWithTime{
            
            storeToDisk(data: data as AnyObject, finalKey: finalKey)
            
        }else if cacheType == Constants.cache.cacheToMemoryWithTime{
            
            storeToCache(data: data as AnyObject, finalKey: finalKey)
            storeToDisk(data: data as AnyObject, finalKey: finalKey)
            
        }else if cacheType == Constants.cache.cacheToMemoryAndDiskWithTime{
            
            storeToCache(data: data as AnyObject, finalKey: finalKey)
            storeToDisk(data: data as AnyObject, finalKey: finalKey)
            
        }else if cacheType == Constants.cache.loadOldCacheAndReplaceWithNew{
            
            storeToCache(data: data as AnyObject, finalKey: finalKey)
            storeToDisk(data: data as AnyObject, finalKey: finalKey)
            
        }
        
        
    }
    
    //MARK: - Retrive data from memCache or from disk -
    public class func retriveCacheData(keyName:String,cachTimelimt:Double,Success:@escaping (Any?)->(),error:@escaping ()->()){
        
        let key = "cacheData-\(keyName)"
        
        isPresent(keyName: keyName, success: { (reteivedData) in
            
            let cachedData = reteivedData as? [String:AnyObject]
            
            if let cacheTime = cachedData?.first?.key{
                
                if cacheExpiryCheck(cacheTime: cacheTime,cachTimelimt:cachTimelimt, key: key){
                     Success(reteivedData)
                }else{
                    error()
                }
            }
        }){
            error()
        }
    }
    
    //MARK: - Store data to disk -
    private class func storeToDisk(data:AnyObject,finalKey:String){

        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
        userDefaults.set(encodedData, forKey: finalKey)
        userDefaults.synchronize()
        
    }
    
    //
    private class func retriveFromDisk(key:String,error:()->(),success:(Any)->()){
        let userDefaults = UserDefaults.standard

        if let decoded  = userDefaults.object(forKey:key) as? Data{
            
            let data = NSKeyedUnarchiver.unarchiveObject(with: decoded)
            if data == nil{
                error()
            }else{
                success(data as Any)
            }
            
        }else{
            
            error()
        }
        
    }
    
    //MARK: - Store data to cache -
    private class func storeToCache(data:AnyObject,finalKey:String){
        
        cache.setObject(data, forKey: finalKey as AnyObject)
    }
    
    
    private class func retriveDataFromCache(key:String,error:()->(),success:(Any)->()){
        
        if let data = cache.object(forKey: key as AnyObject) as? [String:AnyObject]{
            
            if data == nil{
                error()
            }else{
                success(data as Any)
            }
            
        }else{
            error()
        }
        
        
    }
    
    
    //    func retriveData(){
    //        retriveDataFromCache(key: key, error: {
    //
    //
    //
    //        }, success: { (reteivedData) in
    //            data = reteivedData
    //        })
    //    }
    
    
    //MARK: - Check if item is present
    private class func isPresent(keyName:String,success:@escaping (Any?)->(),error:@escaping ()->()){

        var userDefaults = UserDefaults.standard
        let time = NSDate()
        let currentTime:Float = Float(time.timeIntervalSince1970 * 1000)
        var counter = 0
     
        let finalKey = "cacheData-\(keyName)"
        
        retriveDataFromCache(key: finalKey, error: {
            retriveFromDisk(key: finalKey, error: {
                print("err from disk")
                error()
                return
            }, success: { (reteivedData) in
                print("succ from disk")
                success(reteivedData)
                return
            })
            
        }) { (data) in
            
            success(data)
            return
            print("came from cache 'MEMORY'")
            
        }
    
    }

    //cache time - timeStamp attached to URL
    //cacheTimelimit - minute for url cache
    
    //CurrentT-CTL => someT
    
//    if CT > someT{
//    
//    }
    
    private class func cacheExpiryCheck(cacheTime:String,cachTimelimt:Double,key:String) -> Bool{
        
        let userDefaults = UserDefaults.standard
        
        if cacheTime == "0"{
            return true
        }
        
        let time = NSDate()
        let currentTime:Double = time.timeIntervalSince1970 * 1000
        let cachedTime = Double(cacheTime) ?? 0
        let timeDifference:Double = currentTime - cachTimelimt
        
        if timeDifference <= cachedTime{
            
            return true
            
        }else{
            
            userDefaults.remove(key)
            Cache.cache.removeObject(forKey: key as! AnyObject)
            print("data removed for ns")
            return false
            
        }
        
        
    }
    
    
}
