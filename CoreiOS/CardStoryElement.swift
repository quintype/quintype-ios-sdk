//
//  File.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class CardStoryElement:SafeJsonObject {
    
    //Common data
    public var id: String?
    public var title: String?
    public var Description: String?
    public var text: String?
    public var type: String?
    public var page_url: String?
    public var subtype: String?
    public var polltype_id: NSNumber?
    
    //Image related data
    public var hero_image_s3_key: String?
    
    //js related data
    public var embed_js: String?
    public var embed_url: String?
    public var url: String?
    
    //TODO:- find why again story_element is called here
    //    public var story_elements: [CardStoryElement] = []
    //    public var decodedJsEmbed: String?
    //    public var videoId:String?
    //    public var tweetId: NSNumber?
    
    
    public var hero_image_metadata: ImageMetaData?
    public var metadata: CardStoryElementSubTypeMetaData?
    
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "hero_image_metadata" {
            hero_image_metadata = ImageMetaData()
            hero_image_metadata?.setValuesForKeys(value as! [String: AnyObject])
        }
        else if key == "metadata" {
            metadata = CardStoryElementSubTypeMetaData()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.metadata?.setValuesForKeys(data )
            })
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    
}




