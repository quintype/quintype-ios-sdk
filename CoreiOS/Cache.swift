//
//  Cache.swift
//  CoreiOS
//
//  Created by Albin CR on 12/14/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

open class Cache{
    
    private init(){}
    
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
    public class func cacheData(data:Any,key:String,cacheTimeInMinute:Int,saveToDisk:Bool){
        
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
        
        storeToCache(data: data as AnyObject, finalKey: finalKey)
        
        if saveToDisk{
            storeToDisk(data: data as AnyObject, finalKey: finalKey)
        }
        
        
    }
    
    //MARK: - Retrive data from memCache or from disk -
    public class func retriveCacheData(keyName:String,completion:(Any?)->()){
        
        var userDefaults = UserDefaults.standard
        let time = NSDate.init()
        let currentTime:Float = Float(time.timeIntervalSince1970 * 1000)
        let cacheKey = "cacheKey-\(keyName)-"
        let preKey = "cacheData-"
        var data:Any?
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print(key)
            
            if key.hasPrefix(preKey){
                
                
                if key.components(separatedBy: "cacheKey-")[1] == keyName {
                    
                    let initialKeySplit = key.components(separatedBy: "-")
                    let cacheCreatedTimeKey = Float(initialKeySplit[2])
                    let cacheExpireTimeKey = Float(initialKeySplit[4])
                    let timeDifference = currentTime - cacheCreatedTimeKey!
                    
                    func retriveData(){
                        retriveDataFromCache(key: key, error: {
                            
                            retriveFromDisk(key: key, error: {
                                
                            }, success: { (reteivedData) in
                                data = reteivedData
                                storeToCache(data: data as AnyObject, finalKey: key)
                            })
                            
                        }, success: { (reteivedData) in
                            data = reteivedData
                        })
                    }
                    
                    if cacheExpireTimeKey == 0{
                        retriveData()
                    }else{
                        
                        if timeDifference < cacheExpireTimeKey!{
                            retriveData()
                        }
                    }
                }
            }
        }
        completion(data)
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
    
}
