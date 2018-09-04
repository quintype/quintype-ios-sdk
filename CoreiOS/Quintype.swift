
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
import SystemConfiguration

open class Quintype{
    
    public init() {}
    
    var delegate: Completion?
    
    //MARK: - SharedInatance for Quintype
    public static let sharedInstance:Quintype = Quintype()
    
    //MARK: - Private internal variable -
    private var _api:ApiService?
    private var _downloader:Downloader?
    private var _parser:ApiParser?
    private var _analytics:Analytics?
    private var _cache:Cache?
    private var _publisherConfig:Config?
    private var _http:Http?
    private var _baseURL:String?
    
    
    //MARK: - Open variable for direct access - Api Services
    open static var api:ApiService{
        get{
            if Quintype.sharedInstance._api == nil{
                Quintype.sharedInstance._api = ApiService()
            }
            return Quintype.sharedInstance._api!
        }
    }
    
    
    open static var http:Http{
        get{
            if Quintype.sharedInstance._http == nil{
                Quintype.sharedInstance._http = Http()
            }
            return Quintype.sharedInstance._http!
        }
    }
    
    
    //    public var isInternetActive = isInternetAvailable()
    
    open class func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    open static var publisherConfig:Config?
    
    //MARK: - Open variable for direct access - Analytic
    open static var analytics:Analytics{
        get{
            if Quintype.sharedInstance._analytics == nil{
                Quintype.sharedInstance._analytics = Analytics()
            }
            return Quintype.sharedInstance._analytics!
        }
    }
    
    //MARK: - open variable for parser
    
    open static var ApiParesr:ApiParser{
        get{
            if Quintype.sharedInstance._parser == nil{
                Quintype.sharedInstance._parser = ApiParser()
            }
            return Quintype.sharedInstance._parser!
        }
    }
    
    //MARK: - open variable Downloader
    open static var downloader:Downloader{
        get{
            if Quintype.sharedInstance._downloader == nil{
                Quintype.sharedInstance._downloader = Downloader()
            }
            return Quintype.sharedInstance._downloader!
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
        
        //        api.getPublisherConfig(cache: cacheOption.loadOldCacheAndReplaceWithNew, Success: { (data) in
        //
        //            Quintype.cachePublisherKeys(data: data)
        //
        //        }) { (error) in }
        
    }
    
    static func cachePublisherKeys(data:Config?){
        let defaults = UserDefaults.standard
        defaults.set(data?.publisher_id, forKey: Constants.publisherConfig.publisherKey)
        defaults.set(data?.shrubbery_host, forKey: Constants.analyticConfig.analyticKey)
        defaults.set(data?.publisher_name, forKey: Constants.publisherConfig.appNameKey)
        defaults.set(data?.stripe_publishable_key, forKey: Constants.payment.stripeKey)
        defaults.set(data?.cdn_name, forKey: Constants.publisherConfig.cdnNameKey)
        defaults.set(data?.cdn_image, forKey: Constants.publisherConfig.cdnImageKey)
        defaults.set(data?.sketches_host, forKey: Constants.publisherConfig.sketchesHostKey)
        defaults.set(data?.num_headlines, forKey: Constants.publisherConfig.noOfStoriesOnTopKey)
        defaults.set(data?.initial_stories_per_page, forKey: Constants.publisherConfig.noOfStoriesPerPageKey)
        defaults.set(data?.typekit_id, forKey: Constants.publisherConfig.typekitKey)
        defaults.set(data?.story_slug_format, forKey: Constants.publisherConfig.storySlugFormatKey)
        defaults.set(data?.nudge_host, forKey:Constants.publisherConfig.nudgeHostKey)
        defaults.set(data?.polltype_host, forKey: Constants.publisherConfig.polltypeHostKey)
        defaults.set(data?.razorpay_gateway_key, forKey: Constants.publisherConfig.razorpayKey)
        
    }
    
}
