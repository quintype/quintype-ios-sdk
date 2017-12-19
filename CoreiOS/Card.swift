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
    public var metadata:CardMetadata?
    public var card_added_at: NSNumber?
    
    //TODO: - find where these are used and why these are used
    
    //    public var index: Int!
    //    public var totalCards: Int!
    //    public var cardUpdatedAt: Int!
    //    public var cardAddedAt: Int!
    //    public var subType:String!
    
    
    override public func setValue(_ value: Any?, forKey key: String) {
        
        if key == "story_elements" {
            
            for section in value as! [[String:AnyObject]]{
                let singleCardStoryElement = CardStoryElement()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleCardStoryElement.setValuesForKeys(data)
                    self.story_elements.append(singleCardStoryElement)
                    //print(self.story_elements)
                })
            }
            
        }
        else if key == "metadata"{
            if let valued = value as? [String:AnyObject]{
                 let cardMetadata = CardMetadata()
                 cardMetadata.setValuesForKeys(valued)
                self.metadata = cardMetadata
            }
           
            
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    
}

