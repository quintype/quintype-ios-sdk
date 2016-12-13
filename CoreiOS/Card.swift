//
//  Card.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Card:SafeJsonObject  {
    
    public var id: String?
    public var content_id: String?
    public var status: String?
    public var content_version_id: String!
    public var version: NSNumber?
    public var story_elements: [CardStoryElement] = []
    
    //TODO: - find where these are used and why these are used
    
    //    public var index: Int!
    //    public var totalCards: Int!
    //    public var cardUpdatedAt: Int!
    //    public var cardAddedAt: Int!
    //    public var subType:String!
    
    
    override public func setValue(_ value: Any?, forKey key: String) {
        
        if key == "story_elements" {
            var singleCardStoryElement = CardStoryElement()
            for var CardStoryElement in value as! [[String:AnyObject]]{
                
                Converter.jsonKeyConverter(dictionaryArray: CardStoryElement, completion: { (data) in
                    singleCardStoryElement.setValuesForKeys(data as! [String: AnyObject])
                    self.story_elements.append(singleCardStoryElement)
                    print(self.story_elements)
                })
            }
            
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    
}

