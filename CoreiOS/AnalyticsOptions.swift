//
//  AnalyticsOptions.swift
//  CoreiOS
//
//  Created by Albin CR on 12/19/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public enum eventType:String{
    
    case session = "session"
    case viewPage = "page-view"
    case viewStory = "story-view"
    case storyElementView = "story-element-view"
    case storyElementAction = "story-element-action"
    case contentShare = "content-share"

}

public enum pageType:String{
    
    case home = "home"
    case story = "story"
    case section = "section"
    case comment = "comment"
    case profile = "profile"
    case searchResults = "story-search-results"
    
}
