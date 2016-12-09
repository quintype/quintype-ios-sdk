//
//  File.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation
//public class Story {
//
//    public var updatedAt: Double?
//    public var assigneeId: String?
//    public var authorName: String?
//    public var tags: [Tag]?
//    public var headline: String?
//    public var storylineId: String?
//    public var storyContentId: String?
//    public var isPublished: String?
//    public var slug: String?
//    public var lastPublishedAt: Double?
//    public var sections: [Section]?
//    public var ownerName: String?
//    public var pushNotification: String?
//    public var publisherId: String?
//    public var comments: String?
//    public var publishedAt: Double?
//    public var storylineTitle: String?
//    public var summary: String?
//    public var status: String?
//    public var heroImageS3Key: String?
//    public var cards: [Card]?
//    public var storyVersionId: String?
//    public var authorId: String?
//    public var ownerId: String?
//    public var firstPublishedAt: Double?
//    public var heroImageCaption: String?
//    public var version: String?
//    public var bulletType: String?
//    public var createdAt: Double?
//    public var assigneeName: String?
//    public var heroImageMetadata: ImageMetaData?
//    public var storyTemplate: String?
//    public var typeVideo:String?
//    public var subType:String?
//
//}


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
            var singleSection = Section()
            for var section in value as! [[String:AnyObject]]{

                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleSection.setValuesForKeys(data as! [String: AnyObject])
                    self.sections.append(singleSection)
                    print(self.sections)
                })
            }
            
        }else if key == "hero_image_metadata"{
         
            hero_image_metadata = ImageMetaData()
             Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
            self.hero_image_metadata?.setValuesForKeys(data as! [String: AnyObject])
            })
        
        }
        else if key == "tags"{
            var singleTag = Tag()
            
            for var tag in value as! [[String:AnyObject]]{
                
                Converter.jsonKeyConverter(dictionaryArray: tag, completion: { (data) in
                    singleTag.setValuesForKeys(data as! [String: AnyObject])
                    self.tags.append(singleTag)
                    print(self.tags)
                })
  
            }
            
            
        }
        else if key == "cards"{
            var singleCards = Card()
            
            for var card in value as! [[String:AnyObject]]{
                
                Converter.jsonKeyConverter(dictionaryArray: card, completion: { (data) in
                    singleCards.setValuesForKeys(data as! [String: AnyObject])
                    self.cards.append(singleCards)
                    print(self.cards)
                })
                
            }
            
            
        }
            else {
            super.setValue(value, forKey: key)
        }
    }
}
