//
//  config.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Config:SafeJsonObject{
    
    
    public var stripe_publishable_key:String?
    public var sketches_host:String?
    public var facebook:Facebook?
    public var sections:[SectionMeta] = []
    public var social_links:SocialLinks?
    public var layout:Layout?
    public var cdn_name:String?
    public var publisher_id:NSNumber?
    public var num_headlines:NSNumber?
    public var publisher_name:String?
    public var env:String?
    public var initial_stories_per_page:NSNumber?
    public var typekit_id:String?
    public var cdn_image:String?
    public var story_slug_format:String?
    public var shrubbery_host:String?
    public var nudge_host:String?
    public var num_more_stories:NSNumber?
    public var polltype_host:String?
    public var razorpay_gateway_key:String?
    public var story_attributes:[StoryAttributes] = []
    public var mins_between_refreshes:NSNumber?
    
    
    
    
    
    override public func setValue(_ value: Any?, forKey key: String) {
        
        
        if key == "sections" {
          
            for section in value as! [[String:AnyObject]]{
                  let singleSectionMeta = SectionMeta()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleSectionMeta.setValuesForKeys(data)
                    self.sections.append(singleSectionMeta)
                    
                })
            }
            
        } else if key == "story_attributes" {
            
            for section in value as! [[String:AnyObject]]{
                let singleStoryAttributes = StoryAttributes()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleStoryAttributes.setValuesForKeys(data)
                    self.story_attributes.append(singleStoryAttributes)
                    
                })
            }
            
        }
        else if key == "facebook"{
            
            facebook = Facebook()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.facebook?.setValuesForKeys(data)
                //print(self.facebook)
                
            })
            
            
        }else if key == "social_links"{
            
            social_links = SocialLinks()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.social_links?.setValuesForKeys(data)
            })
            
        }
        else if key == "layout"{
            
            layout = Layout()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.layout?.setValuesForKeys(value as! [String: AnyObject])
            })
            
        }
        else {
            super.setValue(value, forKey: key)
        }
    }

    
}



