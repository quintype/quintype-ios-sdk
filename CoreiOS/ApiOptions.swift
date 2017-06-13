//
//  ApiOptions.swift
//  CoreiOS
//
//  Created by Albin CR on 12/1/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

//MARK: - API options for paramenter

public enum storiesOption {
    
    case topStories
    case section(sectionName:String)
    case tag(tagName:String)
    case template(templateName:String)
    case storyGroup(storyGroupName:String)
    case storyGroupInSection(storyGroupName:String,sectionName:String)
    case storyOrder(storyIds:[String])
    case attribute(attributeKey:String,attributeValue:String)
    
    var value: [String:String]? {
        
        switch self {
            
        case .topStories:
            return nil
        case .section(let sectionName):
            return [Constants.story.section: sectionName]
        case .tag(let tagName):
            return [Constants.story.tag: tagName]
        case .template(let templateName):
            return [Constants.story.template: templateName]
        case .storyGroup(let storyGroupName):
            return [Constants.story.storyGroup: storyGroupName]
        case .storyGroupInSection(let storyGroupName,let sectionName):
            return [Constants.story.storyGroup: storyGroupName,Constants.story.section: sectionName]
        case .storyOrder(let storyIds):
            return [Constants.story.storyOrder: storyIds.joined(separator: ",")]
            
        case .attribute(let attributeKey,let attributeValue):
            
            var newKey = Constants.story.storyAttribute
            
            newKey = newKey.appending("." + attributeKey)
            
            return [newKey:attributeValue]
        }
    }
}


public enum searchOption {
    
    case authorName(authorName:String)
    case authorId(authorId:String)
    case key(string:String)
    
    var value: [String:String]? {
        
        switch self {
            
        case .authorName(let authorName):
            return ["author": authorName]
        case .authorId(let authorId):
            return ["author-id": authorId]
        case .key(let string):
            return ["q": string]
            
        }
    }
}

public enum publisherOption {
    
    case all
    case key(keyName:String)
    
    
    var value: [String:String]? {
        
        switch self {
            
        case .all:
            return nil
        case .key(let keyName):
            return ["key": keyName]
            
        }
    }
}


