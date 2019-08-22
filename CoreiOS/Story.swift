//
//  File.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation




@objcMembers
public final class Alternative: SafeJsonObject {
    public var hero_image_s3_key: String?
    public var hero_image_caption: String?
    public var hero_image_metadata: ImageMetaData?
    public var hero_image_attribution : String?
    public var hero_image_url: String?
    public var headline: String?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "headline" {
            if let unwrappedVal = value as? String {
                self.headline = unwrappedVal
            }
        } else if key == "hero_image" {
            if let unwrappedVal = value as? [String: AnyObject] {
                Converter.jsonKeyConverter(dictionaryArray: unwrappedVal) { (data) in
                    for (_, obj) in data.enumerated() {
                        if obj.key == "hero_image_s3_key", let val = obj.value as? String {
                            self.hero_image_s3_key = val
                        } else if obj.key == "hero_image_url", let val = obj.value as? String {
                            self.hero_image_url = val
                        } else if obj.key == "hero_image_caption", let val = obj.value as? String {
                            self.hero_image_caption = val
                        } else if obj.key == "hero_image_attribution", let val = obj.value as? String {
                            self.hero_image_attribution = val
                        } else if obj.key == "hero_image_metadata", let val = obj.value as? [String: AnyObject] {
                            Converter.jsonKeyConverter(dictionaryArray: val, completion: { (data) in
                                let meta = ImageMetaData()
                                meta.setValuesForKeys(data)
                                self.hero_image_metadata = meta
                            })
                        }
                    }
                }
            }
        }
    }
}

@objcMembers
public class Story:SafeJsonObject, NSCopying {
    
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
    public var story_template: StoryTemplet? = StoryTemplet.Default
    public var storyTemplateString: String?
    
    public var content_type:String?
    public var access_level_value: NSNumber?
    public var access: Access?
    
    public var cards: [Card] = []
    public var tags: [Tag] = []
    public var hero_image_metadata: ImageMetaData?
    public var sections: [Section] = []
    public var id:String?
    public var subheadline :String?
    
    public var linkedStories:[String:LinkedStory] = [:]
    public var storyMetadata:StoryMetadata?
    public var linked_entities:[[String:AnyObject]]?
    public var authors : [Author] = []
    public var contributors:[Contributors] = []
    
    public var hero_image_attribution : String?
    
    public var engagment:Engagement?
    public var imageAttributtedCaptionText:NSAttributedString?
    public var parentSection:String?
    
    public var alternative: Alternative?
    
    public var associated_series_collection_ids:[String] = []
    public var storyReadTime:String?
    public var url:String?
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let story =  Story()
        story.id = self.id
        story.sections = self.sections
        story.hero_image_metadata = self.hero_image_metadata
        story.tags = self.tags
        story.cards = self.cards
        story.content_type = self.content_type
        story.story_template = self.story_template
        story.storyTemplateString = self.storyTemplateString
        story.bullet_type = self.bullet_type
        story.version = self.version
        story.push_notification = self.push_notification
        story.published_at = self.published_at
        story.last_published_at = self.last_published_at
        story.first_published_at = self.first_published_at
        story.storyline_title = self.storyline_title
        story.hero_image_caption = self.hero_image_caption
        story.hero_image_s3_key = self.hero_image_s3_key
        story.summary = self.summary
        story.comments = self.comments
        story.slug = self.slug
        story.status = self.status
        story.story_content_id = self.story_content_id
        story.storyline_id = self.storyline_id
        story.headline = self.headline
        story.created_at = self.created_at
        story.owner_id = self.owner_id
        story.assignee_name = self.assignee_name
        story.assignee_id = self.assignee_id
        story.owner_name = self.owner_name
        story.author_id = self.author_id
        story.story_version_id = self.story_version_id
        story.publisher_id = self.publisher_id
        story.author_name = self.author_name
        story.updated_at = self.updated_at
        story.alternative = self.alternative
        story.access_level_value = self.access_level_value
        story.access = self.access
        story.associated_series_collection_ids = self.associated_series_collection_ids
        story.url = self.url
        return story
    }
    
    
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
            
            if self.sections.count > 0{
                self.parentSection =  self.getParentSection(section: self.sections[0])
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
            hero_image_metadata = image
            
        }
        else if key == "tags"{
            
            for tag in value as! [AnyObject]{
                if !(tag is NSNull) {
                    if let unwrappedTag = tag as? [String: AnyObject] {
                        let singleTag = Tag()
                        Converter.jsonKeyConverter(dictionaryArray: unwrappedTag, completion: { (data) in
                            singleTag.setValuesForKeys(data )
                            self.tags.append(singleTag)
                            //print(self.tags)
                        })
                    }
                }
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
            
        }else if key == "authors"{
            guard let unwrappedAuthorsArray = value as? [[String:AnyObject]] else{
                return
            }
            for authorsJson in unwrappedAuthorsArray {
                
                let author = Author()
                Converter.jsonKeyConverter(dictionaryArray: authorsJson, completion: { (data) in
                    author.setValuesForKeys(data )
                    self.authors.append(author)
                })
                
            }
            
        }
        else if key == "contributors"{
            guard let unwrappedAuthorsArray = value as? [[String:AnyObject]] else{
                return
            }
            for authorsJson in unwrappedAuthorsArray {
                
                let contributor = Contributors()
                Converter.jsonKeyConverter(dictionaryArray: authorsJson, completion: { (data) in
                    contributor.setValuesForKeys(data )
                    self.contributors.append(contributor)
                })
                
            }
            
        }
        else if key == "linked_stories"{
            if let valued = value as? [String:AnyObject]{
                var linkedObjectMap:[String:LinkedStory] = [:]
                for (_,object) in valued.enumerated(){
                    if let innerObject = object.value as? [String:AnyObject]{
                        let linkedObject = LinkedStory()
                        linkedObject.setValuesForKeys(innerObject)
                        linkedObjectMap[object.key] = linkedObject
                    }
                }
                if linkedObjectMap.count > 0{
                    self.linkedStories = linkedObjectMap
                }
            }
        }
        else if key == "linked_entities"{
            self.linked_entities = value as? [[String:AnyObject]]
        }
            
        else if key == "metadata"{
            if let valued = value as? [String:AnyObject]{
                let storyMeta = StoryMetadata()
                storyMeta.setValuesForKeys(valued)
                self.storyMetadata = storyMeta
            }
        }else if key == "story_template"{
            if let unwrappedValue = value as? String{
                self.storyTemplateString = unwrappedValue
                self.story_template = StoryTemplet(value: unwrappedValue)
            }else{
                self.storyTemplateString = "text"
                self.story_template = StoryTemplet.Default
            }
        } else if key == "access" {
            self.access = Access(value: value as? String)
        } else if key == "alternative" {
            if let unwrappedValue = value as? [String: AnyObject] {
                if let homeDict = unwrappedValue["home"] as? [String: AnyObject] {
                    if let defaultDict = homeDict["default"] as? [String: AnyObject] {
                        Converter.jsonKeyConverter(dictionaryArray: defaultDict) { (data) in
                            let alternativeObj = Alternative()
                            alternativeObj.setValuesForKeys(data)
                            self.alternative = alternativeObj
                        }
                        
                    }
                }
            }
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    func getParentSection(section:Section) -> String? {
        guard let sectionID =  section.parent_id?.intValue else{
            return section.name?.lowercased()
        }
        
        guard let config = Quintype.publisherConfig ,config.sections.count > 0 else{
            return nil
        }
        
        let parentSections = config.sections.filter({$0.parent_id?.intValue == nil})
        
        let parentSection = parentSections.filter { (section) -> Bool in
            if let parentId = section.id?.intValue{
                return parentId == sectionID
            }else{
                return false
            }
        }
        
        if parentSection.count > 0{
            
            return parentSection.first?.name?.lowercased()
            
        }else{
            return nil
        }
    }
}


public enum Access: String {
    case Public = "public"
    case Login = "login"
    case Subscription = "subscription"
    case Unknown
    
    init(value: String?) {
        self = Access(rawValue: value ?? "") ?? .Unknown
    }
}

public enum StoryTemplet:String{
    
    case Default
    case Video = "video"
    case LiveBlog = "live-blog"
    case Review = "review"
    case Elsewhere = "news-elsewhere"
    case Photo = "photo"
    case Listicle = "listicle"
    case Explainer = "explainer"
    case PhotoAlbum = "photo-album"
    case Rasipalan = "Rasi-Palan"
    case Gurupeyarchi = "Gurupeyrachi"
    case Episode = "Episode"
    case Text = "text"
    case LongForm
//    case ViewCounterView
    case Unknown
    
    init(value : String?){
        self =  StoryTemplet(rawValue: value ?? "") ?? .Unknown
        
    }
    
}
