//
//  Section.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Section:SafeJsonObject {
    
    public var name: String?
    public var id: NSNumber?
    public var trending_stories_story_order: [String]?
    public var featured_stories_story_order: [String]?
    public var updated_at: NSNumber?
    public var story_order: [String]?
    public var publisher_id: String?
    public var display_name:String?
    
    public var parent_id:NSNumber?
    public var slug:String?
    
    
    
}


