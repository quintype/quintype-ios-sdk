//
//  Quintype.swift
//  CoreiOS
//
//  Created by Albin CR on 12/12/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

open class Quintype{
    
    
    public init() {}
    
    
    //MARK: - SharedInatance for Quintype
    private static let sharedInstance:Quintype = Quintype()
    
    //MARK: - Private internal variable -
    private var _api:ApiService?
    
    
    
    
    //MARK: - Open variable for direct access -
    open static var api:ApiService{
        get{
            if Quintype.sharedInstance._api == nil{
                Quintype.sharedInstance._api = ApiService()
            }
            return Quintype.sharedInstance._api!
        }
    }
    
   
    
    //MARK: - SDK init to obtain base url
    open static func initWithBaseUrl(baseURL: String!) {
        
        let storage = Storage.sharedStorage
        let regExp = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regExp])
        let status = predicate.evaluate(with: baseURL)
        
        precondition(status, "               The Entered URL Is Not Correct.               ")
        
        storage.storageBaseURL(baseURL: baseURL)
        defer {
            api.getPublisherConfig(cache: cacheOption.loadOldCacheAndReplaceWithNew) { (error, data) in
              
            }
        }
        
        
    }
    
    //MARK - publisherConfig linking to Quintype

    
    open static func getPublisherConfig(options:publisherOption,success:@escaping (Any?)->()){
        
        Cache.retriveCacheData(keyName: Constants.publisherConfig.publisherKey) { (data) in
            print(data)
            
            if data == nil{
                print("asdas")
            }else{
                print("got data")
                ApiParser.configParser(data: data as! [String : AnyObject]?, completion: { (configData) in
                    
                    if let opt = options.value{
                        success(configData.value(forKey: opt.values.first!))
                    }else{
                        success(configData)
                    }
                })
                
            }
        }
        
    }
    
    
    
    
}
