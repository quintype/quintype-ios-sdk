//
//  ApiOptions.swift
//  CoreiOS
//
//  Created by Albin CR on 12/1/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

//For post option

//public enum storiesOption {
//    
//    case section(sectionName:String)
//    
//    
//    
//    
//    var value: [String:String] {
//        
//        switch self {
//            
//        case .section(let sectionName):
//            return ["section": sectionName]
//        
//            
//            
//        }
//        
//    }
//}


  //,template,section+story-group

public enum storiesOption {
    
    case topStories
    case section(sectionName:String)
    case tag(tagName:String)
    case template(templateName:String)
    case storyGroup(storyGroupName:String)
    case storyGroupInSection(storyGroupName:String,sectionName:String)


    var value: [String:String]? {

        switch self {

        case .topStories:
            return nil
        case .section(let sectionName):
            return ["section": sectionName]
        case .tag(let tagName):
            return ["tag": tagName]
        case .template(let templateName):
            return ["template": templateName]
        case .storyGroup(let storyGroupName):
            return ["story-group": storyGroupName]
        case .storyGroupInSection(let storyGroupName,let sectionName):
            return ["story-group": storyGroupName,"section": sectionName]
            

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


