//
//  LinkedStory.swift
//  Pods
//
//  Created by Arjun P A on 03/07/17.
//
//

import Foundation


public class LinkedStory:SafeJsonObject {
    public var headline:String?
    public var story_content_id:String!
    public var slug:String?
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "story-content-id"{
            if let valueD =  value as? String{
                self.story_content_id = valueD
            }
        }
        super.setValue(value, forKey: key)
    }
}

