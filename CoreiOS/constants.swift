//
//  Constants.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

//TODO: - Changed this to get from SDK init


/**
 
 1. Contains all the constants in 'Struct' format
 2. Contains all the url creation function in 'Enum'
 
 **/



public struct Constants{
    
    static let storage = Storage.sharedStorage
    
    public struct urlConfig{
        
        //MARK: - urlConfig -
        static let getStories = "/api/v1/stories"
        static let configUrl = "/api/v1/config"
        static let search = "/api/v1/search"
        static let getStoryFromSlug = "/api/v1/stories-by-slug"
        static let breakingNews = "/api/v1/breaking-news"
        static let facebookLogin = "/api/login/facebook"
        static let postComment = "/api/v1/comments"
        static let getCurrentUser = "/api/v1/members/me"
        static let GetAuthor =  "/api/v1/authors"
        
        //Function that return string
        static func relatedStories(storyId:String) -> String {return getStories + "/" + storyId + "/related-stories"}
        static func getComments(storyId:String) -> String {return getStories + "/" + storyId + "/comments"}
        static func getBaseUrl() -> String {return storage.getBaseUrl()!}
        
    }
    
    public struct analyticConfig{
        
        //MARK: - analyticConfig -
        
        static let analyticKey = "analyticKey"
        static let analyticEvent = "/api/event"
        
        //Function that return string
    
    }
    
    public struct publisherConfig{
        
        //MARK: - publisherConfig -
        static let publisherCacheKey = "getPublisherConfig"
        static let publisherKey = "publisherId"
        static let cdnNameKey = "cdn_name"
        static let appNameKey = "appName"
        static let cdnImageKey = "cdn_image"
        static let sketchesHostKey = "sketches_host"
        static let noOfStoriesPerPageKey = "initial_stories_per_page"
        static let noOfStoriesOnTopKey = "num_headlines"
        static let typekitKey = "typekit_id"
        static let storySlugFormatKey = "story_slug_format"
        static let nudgeHostKey = "nudge_host"
        static let moreStoryCountKey = "num_more_stories"
        static let polltypeHostKey = "polltype_host"
        static let razorpayKey = "razorpay_gateway_key"
        
        //Constants from user default storage
        public static let publisherId = UserDefaults.standard.integer(forKey: Constants.publisherConfig.publisherKey)
        public static let appName = UserDefaults.standard.string(forKey: Constants.publisherConfig.appNameKey)
        public static let analyticBaseUrl = UserDefaults.standard.string(forKey: Constants.analyticConfig.analyticKey)
        public static let stripId = UserDefaults.standard.string(forKey: Constants.payment.stripeKey)
        public static let cdnLink = UserDefaults.standard.string(forKey: Constants.publisherConfig.cdnNameKey)
        public static let cdnImage = UserDefaults.standard.string(forKey: Constants.publisherConfig.cdnImageKey)
        public static let sketchesHost = UserDefaults.standard.string(forKey: Constants.publisherConfig.sketchesHostKey)
        public static let noOfStoriesPerPage = UserDefaults.standard.integer(forKey: Constants.publisherConfig.noOfStoriesPerPageKey)
        public static let noOfStoriesOnTop = UserDefaults.standard.integer(forKey:Constants.publisherConfig.noOfStoriesOnTopKey)
        public static let typekitId = UserDefaults.standard.string(forKey: Constants.publisherConfig.typekitKey)
        public static let storySlugFormat = UserDefaults.standard.string(forKey: Constants.publisherConfig.storySlugFormatKey)
        public static let nudgeHost = UserDefaults.standard.string(forKey: Constants.publisherConfig.nudgeHostKey)
        public static let moreStoryCount = UserDefaults.standard.string(forKey: Constants.publisherConfig.moreStoryCountKey)
        public static let polltypeHost = UserDefaults.standard.stringArray(forKey: Constants.publisherConfig.polltypeHostKey)
        public static let razorpayId = UserDefaults.standard.string(forKey: Constants.publisherConfig.razorpayKey)
        
        
    }
    public struct user{
        
        //MARK: - User detaisl -
        static let memberkey = "memberId"
        static let memberName = "memberName"
        
        //Constants from user default storage
        static let memberId = UserDefaults.standard.integer(forKey: Constants.user.memberkey)
        
        
        
    }
    
    public struct cache{
        
        //MARK: - cache detaisl -
        static let cacheToMemoryWithTime = "cacheToMemoryWithTime"
        static let cacheToDiskWithTime = "cacheToDiskWithTime"
        static let cacheToMemoryAndDiskWithTime = "cacheToMemoryAndDiskWithTime"
        static let loadOldCacheAndReplaceWithNew = "loadOldCacheAndReplaceWithNew"
        static let none = "none"
        
    }
    public struct story{
        
        //MARK: - Story detaisl -
        static let section = "section"
        static let tag = "tag"
        static let template = "template"
        static let storyGroup = "story-group"
        
    }
    public struct payment{
        
        static let stripeKey = "stripe_publishable_key"
        
    }
    
    public struct login{
        
        static let auth = "x-qt-auth"
        
    }
    
    struct HttpError{
        
        static let pageNotFound = "Unable to retrive data. Please try again after sometime"
        static let noInternetConnection = "No internet connection. Please try again after sometime"
        
    }
    
}




