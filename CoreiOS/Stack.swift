//
//  Stack.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Stack:SafeJsonObject{
    
    public var show_on_locations: [String]?
    public var background_color:String?
    public var rank:NSNumber?
    public var type:String?
    public var story_group:String?
    public var max_stories: NSNumber?
    public var id:NSNumber?
    public var show_on_all_sections_:Bool?
    public var heading:String?
    
    
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.show_on_locations = aDecoder.decodeObject(forKey: "show_on_locations") as? [String]
        self.background_color = aDecoder.decodeObject(forKey: "background_color") as? String
        self.rank = aDecoder.decodeObject(forKey: "rank") as? NSNumber
        self.type = aDecoder.decodeObject(forKey: "type") as? String
        self.story_group = aDecoder.decodeObject(forKey: "story_group") as? String
        self.max_stories = aDecoder.decodeObject(forKey: "max_stories") as? NSNumber
        self.id = aDecoder.decodeObject(forKey: "id") as? NSNumber
        self.show_on_all_sections_ = aDecoder.decodeObject(forKey: "show_on_all_sections_") as? Bool
        self.heading = aDecoder.decodeObject(forKey: "heading") as? String
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(show_on_locations, forKey: "show_on_locations")
        aCoder.encode(background_color, forKey: "background_color")
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(story_group, forKey: "story_group")
        aCoder.encode(max_stories, forKey: "max_stories")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(show_on_all_sections_, forKey: "show_on_all_sections_")
        aCoder.encode(heading, forKey: "heading")
    }
    
    
    
    
}
