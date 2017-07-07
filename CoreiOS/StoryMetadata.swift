//
//  StoryMetadata.swift
//  Pods
//
//  Created by Arjun P A on 05/07/17.
//
//

import Foundation


public class StoryMetadata:SafeJsonObject{
    public var story_attributes:[String:AnyObject]?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "story-attributes"{
            if let valued = value as? [String:AnyObject]{
                story_attributes = valued
            }
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
}
