//
//  File.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation


public class Story:SafeJsonObject {
    
    public var updated_at: NSNumber?
    public var assignee_id: NSNumber?
    public var author_name: String?//
    public var publisher_id: NSNumber?//
    public var story_version_id: String?//
    public var author_id: NSNumber?//
    public var owner_name: String?
    public var assignee_name: String?
    public var owner_id: NSNumber?
    public var created_at: NSNumber?
    
    public var headline: String?//
    public var storyline_id: NSNumber?
    public var story_content_id: String?
    public var status: String?//isPublished
    public var slug: String?//
    public var comments: String?
    public var summary: String?
    public var hero_image_s3_key: String?//
    public var hero_image_caption: String?
    public var storyline_title: String?
    
    public var first_published_at: NSNumber?//
    public var last_published_at: NSNumber?//
    public var published_at: NSNumber?
    
    public var push_notification: String?
    public var version: NSNumber?
    public var bullet_type: String?
    public var story_template: String?
    public var content_type:String?
   
    public var cards: [Card] = []
    public var tags: [Tag] = []
    public var hero_image_metadata: ImageMetaData?
    public var sections: [Section] = []
    
    
    

    


    override public func setValue(_ value: Any?, forKey key: String) {
        
        if key == "sections" {
            
            for  section in value as! [[String:AnyObject]]{
                let singleSection = Section()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleSection.setValuesForKeys(data )
                    self.sections.append(singleSection)
                    //print(self.sections)
                })
            }
            
        }else if key == "hero_image_metadata"{
         
            let image = ImageMetaData()
            let data = value as? [String : AnyObject]
            
            if let width = data?["width"] as? NSNumber{
                image.width = width
            }
            if let height = data?["height"] as? NSNumber{
                image.height = height
            }
            if let focusPoint = data?["focus-point"] as? [NSNumber]{
                image.focus_point = focusPoint
            }
            print(image)
            hero_image_metadata = image
        
        }
        else if key == "tags"{
            
            
            for tag in value as! [[String:AnyObject]]{
                let singleTag = Tag()
                Converter.jsonKeyConverter(dictionaryArray: tag, completion: { (data) in
                    singleTag.setValuesForKeys(data )
                    self.tags.append(singleTag)
                    //print(self.tags)
                })
  
            }
            
            
        }
        else if key == "cards"{

            for card in value as! [[String:AnyObject]]{
                let singleCards = Card()
                Converter.jsonKeyConverter(dictionaryArray: card, completion: { (data) in
                    singleCards.setValuesForKeys(data )
                    self.cards.append(singleCards)
                    //print(self.cards)
                })
                
            }
            
            
        }
            else {
            super.setValue(value, forKey: key)
        }
    }
}
