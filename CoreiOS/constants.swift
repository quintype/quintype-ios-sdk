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
        static let facebookLogin = "/session/facebook"
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
        static let appNameKey = "appName"
        
        //Constants from user default storage
        static let publisherId = UserDefaults.standard.integer(forKey: Constants.publisherConfig.publisherKey)
        static let appName = UserDefaults.standard.string(forKey: Constants.publisherConfig.appNameKey)
        static let analyticBaseUrl = UserDefaults.standard.string(forKey: Constants.analyticConfig.analyticKey)
        
        
        
        
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
        static let cacheToMemoryAndDiskWithTime = "cacheToMemoryAndDiskWithTime"
        static let loadOldCacheAndReplaceWithNew = "loadOldCacheAndReplaceWithNew"
        
    }
    public struct story{
        
        //MARK: - Story detaisl -
        static let section = "section"
        static let tag = "tag"
        static let template = "template"
        static let storyGroup = "story-group"
        
    }
    
    
    
    //    struct HttpError{
    //
    //    }

    //    struct FileError{
    //
    //    }
    
}




