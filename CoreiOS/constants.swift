//
//  Constants.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

//TODO: - Changed this to get from SDK init
let mainURL = "https://sketches-staging.quintype.com"
let baseURL:String = mainURL + "/api"


/**
 
 1. Contains all the constants in 'Struct' format
 2. Contains all the url creation function in 'Enum'
 
 **/



struct Constants{
    
    //    struct HttpError{
    //
    //    }
    //
    //    struct FileError{
    //
    //    }
    
    struct urlConfig{
        
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


        // good param(single item) sections||sectionid||tag||sort-order(id same as stack) (fields(parmas||default values),offset limit)
        
        
        
        
        var storiesBySlug = NSURL(string:  baseURL + "/stories-by-slug")//good for deep linking,
        
        
        
        var configUrl = NSURL(string:  baseURL + "/config") //good
        var searchUrl = NSURL(string:  baseURL + "/search")//good ?q=,from,size
        var relatedStoriesUrl = NSURL(string:  baseURL + "/related-stories")//id of opened story, fields(parmas||default values),offset limit)
        
        var commentsAndVotesUrl = NSURL(string:  baseURL + "/comments-and-votes")//good -> medium story id
        var postCommentUrl = NSURL(string:  baseURL + "/comment")//good post , check docs
        
        //returns tokens send to server returns token as header
        var facebookLoginUrl = NSURL(string:  baseURL + "https://thequint-web.staging.quintype.io/session/facebook")
        
        
        
        var lastestAppVersionUrl = NSURL(string:  baseURL + "/check-latest-ios-version") // normal update screen
        
        
        /** "api/follow" - post storyline feild
         get gives list of user to follow
         
         **/
        
    }
    
}




