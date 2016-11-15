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
    
    struct HttpError{
        
    }
    
    struct FileError{
        
    }
    
    struct Config{
        
         var storiesUrl = NSURL(string:  baseURL + "/stories")// good param(single item) sections||sectionid||tag||sort-order(id same as stack) (fields(parmas||default values),offset limit)
        var storiesBySlug = NSURL(string:  baseURL + "/stories-by-slug")//good for deep linking,
        var storiesByTemplateUrl = NSURL(string:  baseURL + "/stories")// good param (template) ||
        var configUrl = NSURL(string:  baseURL + "/config") //good
         var searchUrl = NSURL(string:  baseURL + "/search")//good ?q=,from,size
        var relatedStoriesUrl = NSURL(string:  baseURL + "/related-stories")//id of opened story, fields(parmas||default values),offset limit)
        
        var commentsAndVotesUrl = NSURL(string:  baseURL + "/comments-and-votes")//good -> medium story id
        
        
        var postCommentUrl = NSURL(string:  baseURL + "/comment")//good post , check docs
        
        //returns tokens send to server returns token as header
        var facebookLoginUrl = NSURL(string:  baseURL + "/login/facebook")
        var googleLoginUrl = NSURL(string:  baseURL + "/login/google")
        var twitterLoginUrl = NSURL(string:  baseURL + "/login/twitter")
        

        var lastestAppVersionUrl = NSURL(string:  baseURL + "/check-latest-ios-version") // normal update screen

        
        /** "api/follow" - post storyline feild
        get gives list of user to follow
 
        **/
        
    }

}


enum GenerateURL{

    
}

