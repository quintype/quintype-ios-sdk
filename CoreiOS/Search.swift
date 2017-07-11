//
//  Search.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Search:SafeJsonObject{
    
    public var from: NSNumber?
    public var size: NSNumber?
    public var total: NSNumber?
    public var stories: [Story] = []
    public var term: String?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        
        if key == "stories"{
            
            
            for section in value as! [[String:AnyObject]]{
                let singleStory = Story()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleStory.setValuesForKeys(data)
                    self.stories.append(singleStory)
                    //print(self.stories)
                })
            }
            
        }else{
            super.setValue(value, forKey: key)
        }
        
    }
    
}
