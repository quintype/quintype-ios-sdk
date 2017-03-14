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
    public class func cacheData(data:Any,key:String,cacheTimeInMinute:Int,cacheType:String){
        
        let time = NSDate.init()
        
        let preKey = "cacheData-"
        
        var currentTime:String = String(0)
        if cacheTimeInMinute != 0{
            currentTime = String(time.timeIntervalSince1970 * 1000)
        }
        
        let cacheCreatedTimeKey = "cacheCreatedTimeKey-\(currentTime)-"
        let expireTime:String = String(cacheTimeInMinute * 60 * 1000)
        let cacheExpireTimeKey = "cacheExpireTimeKey-\(expireTime)-"
        let cacheKey = "cacheKey-\(key)"
        let finalKey = preKey + cacheCreatedTimeKey + cacheExpireTimeKey + cacheKey
        
    
        
        ////print(finalKey)
        
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
    public class func retriveCacheData(keyName:String,completion:@escaping (Any?)->()){
        print(keyName)
        isPresent(keyName: keyName, success: { (reteivedData) in
            completion(reteivedData)
            //            return
        }){
            completion(nil)
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
        let decoded  = userDefaults.object(forKey:key) as! Data
        let data = NSKeyedUnarchiver.unarchiveObject(with: decoded)
        if data == nil{
            error()
        }else{
            success(data as Any)
        }
    }
    
    //MARK: - Store data to cache -
    private class func storeToCache(data:AnyObject,finalKey:String){
        
        cache.setObject(data, forKey: finalKey as AnyObject)
    }
    
    
    private class func retriveDataFromCache(key:String,error:()->(),success:(Any)->()){
        let data = cache.object(forKey: key as AnyObject)
        if data == nil{
            error()
        }else{
            success(data as Any)
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
    private class func isPresent(keyName:String,success:(Any?)->(),error:()->()){
        
        var userDefaults = UserDefaults.standard
        let time = NSDate.init()
        let currentTime:Float = Float(time.timeIntervalSince1970 * 1000)
//        let cacheKey = "cacheKey-\(keyName)-"
        let preKey = "cacheData-"
        var counter = 0
        
        
        for (key, value) in userDefaults.dictionaryRepresentation() {
            print(key)
            counter = counter + 1
            
            if key.hasPrefix(preKey){
                
                if key.components(separatedBy: "cacheKey-")[1] == keyName {
                    
                    let initialKeySplit = key.components(separatedBy: "-")
                    let cacheCreatedTimeKey = Float(initialKeySplit[2])
                    let cacheExpireTimeKey = Float(initialKeySplit[4])
                    let timeDifference = currentTime - cacheCreatedTimeKey!
                    
                    
                    
                    if cacheExpireTimeKey == 0{
                        
                        retriveDataFromCache(key: key, error: {
                            
                            retriveFromDisk(key: key, error: {
                                print("err from disk")
                                error()
                                return
                            }, success: { (reteivedData) in
                                print("succ from disk")
                                success(reteivedData)
                                
                                return
                            })
                            
                        }, success: { (reteivedData) in
                            print("succ from cache")
                            success(reteivedData)
                            return
                        })
                        
                    }else{
                        
                        if timeDifference < cacheExpireTimeKey!{
                            
                            retriveDataFromCache(key: key, error: {
                                
                                retriveFromDisk(key: key, error: {
                                    print("err from disk")
                                    error()
                                    return
                                }, success: { (reteivedData) in
                                    print("succ from disk")
                                    success(reteivedData)
                                    return
                                })
                                
                            }, success: { (reteivedData) in
                                print("succ from cache")
                                success(reteivedData)
                                return
                            })
                            
                            
                            
                        }else{
                            userDefaults.remove(key)
                            cache.removeObject(forKey: key as! AnyObject)
                            print("data removed for ns")
                            error()
                            return
                        }
                    }
                }
            }
            else if counter == userDefaults.dictionaryRepresentation().count{
                print("not in ud")
                error()
                return
            }
        }
        
        
        
    }
    
    
    
    
    
}
