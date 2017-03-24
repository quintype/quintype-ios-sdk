//
//  Collections.swift
//  Quintype
//
//  Created by Albin CR on 3/24/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation


public class Collections:SafeJsonObject  {
    
    public var updated_at:NSNumber?
    public var slug:String?
    public var name:String?
    public var automated:Bool?
    public var template:String?
//    public var rules:[Rules] = []
    public var summary:String?
    public var id:NSNumber?
    public var total_count:NSNumber?
    public var items:String?
    public var created_at:NSNumber?
    
    
    
    override public func setValue(_ value: Any?, forKey key: String) {
        
        if key == "story_elements" {
            
//            for section in value as! [[String:AnyObject]]{
//                let singleCardStoryElement = CardStoryElement()
//                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
//                    singleCardStoryElement.setValuesForKeys(data)
//                    self.story_elements.append(singleCardStoryElement)
//                    //print(self.story_elements)
//                })
//            }
            
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    
}

