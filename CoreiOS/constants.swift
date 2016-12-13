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
    
    private static var baseUrl:String?
    
    //    struct HttpError{
    //
    //    }
    //
    //    struct FileError{
    //
    //    }
    
  public  struct urlConfig{
        
        static let getStories = "/api/v1/stories"
        static let configUrl = "/api/v1/config"
        static let search = "/api/v1/search"
        static let getStoryFromSlug = "/api/v1/stories-by-slug"
        static let breakingNews = "/api/v1/breaking-news"
        static let facebookLogin = "/session/facebook"
        static let postComment = "/api/v1/comments"
        static let getCurrentUser = "/api/v1/members/me"
        static let GetAuthor =  "/api/v1/authors"
        
        static func relatedStories(storyId:String) -> String{return getStories + "/" + storyId + "/related-stories"}
        static func getComments(storyId:String) -> String{return getStories + "/" + storyId + "/comments"}
        
        static func getBaseUrl() -> String{
            
            return storage.getBaseUrl()!
            
        }

    }
    
}




