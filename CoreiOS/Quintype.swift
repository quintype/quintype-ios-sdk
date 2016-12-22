//
//  Quintype.swift
//  CoreiOS
//
//  Created by Albin CR on 12/12/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

protocol Completion{
   func finished()
}


import Foundation

open class Quintype{
    
    
    public init() {}
    
    var delegate: Completion?
    
    //MARK: - SharedInatance for Quintype
    public static let sharedInstance:Quintype = Quintype()
    
    //MARK: - Private internal variable -
    private var _api:ApiService?
    
    private var _analytics:Analytics?

    //MARK: - Open variable for direct access - Api Services
    open static var api:ApiService{
        get{
            if Quintype.sharedInstance._api == nil{
                Quintype.sharedInstance._api = ApiService()
            }
            return Quintype.sharedInstance._api!
        }
    }
    
    //MARK: - Open variable for direct access - Analytic
    open static var analytics:Analytics{
        get{
            if Quintype.sharedInstance._analytics == nil{
                Quintype.sharedInstance._analytics = Analytics()
            }
            return Quintype.sharedInstance._analytics!
        }
    }

    //MARK: - SDK init to obtain base url
    open static func initWithBaseUrl(baseURL: String!) {
        let defaults = UserDefaults.standard
        let storage = Storage.sharedStorage
        let regExp = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regExp])
        let status = predicate.evaluate(with: baseURL)
        
        precondition(status, "               The Entered URL Is Not Correct.               ")
        
        storage.storageBaseURL(baseURL: baseURL)
        
        api.getPublisherConfig(cache: cacheOption.loadOldCacheAndReplaceWithNew) { (error, data) in
            
            //Set publisher id
            defaults.set(data?.publisher_id, forKey: Constants.publisherConfig.publisherKey)
            defaults.set(data?.shrubbery_host, forKey: Constants.analyticConfig.analyticKey)
            defaults.set(data?.publisher_name, forKey: Constants.publisherConfig.appNameKey)
            
            if error == nil{
                if let delegate = Quintype.sharedInstance.delegate{
                    delegate.finished()
                }
            }
            
        }
        
    }
    
    //MARK - publisherConfig linking to Quintype
    
    
    open static func getPublisherConfig(options:publisherOption,success:@escaping (Any?)->()){
        
        Cache.retriveCacheData(keyName: Constants.publisherConfig.publisherKey) { (data) in
           //print(data as Any)
            
            if data == nil{
               //print("asdas")
            }else{
               //print("got data")
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
