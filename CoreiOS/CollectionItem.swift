//
//  CollectionItem.swift
//  Quintype
//
//  Created by Pavan Gopal on 10/25/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation

open class CollectionItem:SafeJsonObject, NSCopying{
    
    open var id:NSNumber?
    open var name:String?
    open var slug:String?
    open var template:String?
    open var type:String?
    open var collection:CollectionModel?
    open var story:Story?
    
    public var associatedMetadata: AssociatedMetadata?
    
    
    override open func setValue(_ value: Any?, forKey key: String) {
        
        if key == "story"{
            let datad = ["story":value]
            ApiParser.storyParser(data: datad as [String : AnyObject]?, completion: { (story) in
                self.story = story
            })
        }else if key == "associated_metadata" {
            let associatedMetadata = AssociatedMetadata()
            
            if let valuesD = value as? [String:Any] {
                associatedMetadata.setValuesForKeys(valuesD)
            }
            
            self.associatedMetadata = associatedMetadata
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    required override public init(){
        super.init()
    }
    required public init(item:CollectionItem) {
        item.id = id
        item.name = name
        item.slug = slug
        item.template = template
        item.type = type
        item.collection = collection
        item.story = story
    }
    
    open func copy(with zone: NSZone? = nil) -> Any{
        let item:CollectionItem = CollectionItem.init()
        item.id = id
        item.name = name
        item.slug = slug
        item.template = template
        item.type = type
        item.collection = collection
        item.story = story
        return item
        
    }
}

public class AssociatedMetadata:SafeJsonObject {
    
    public var layout: String?
    public var show_arrows:Bool = false
    public var slider_type_dots : Bool = true
    
    public var show_author_name : Bool = true
    public var number_of_slides_to_show : Int = 0
    public var number_of_slides_to_scroll : Int = 0
    public var show_section_tag : Bool = false
    public var show_time_of_publish : Bool = false
    public var set_scroll_speed : Int = 0
    
    public var show_collection_name : Bool = true
    public var slider_type_dashes : Bool = false
    public var enable_auto_play : Bool = false
    public var full_width_container : Bool = false
    public var number_of_stories_to_show : Int = 0
    
    public var theme:Theme = Theme.Dark
    
    public enum Theme:String{
        case Dark = "dark"
        case Unknown
        
        init(value:Any?){
            
            if let valueD = value as? String{
                self = Theme(rawValue: valueD) ?? .Unknown
            }else{
                self = .Unknown
            }
            
        }
    }
    
    override open func setValue(_ value: Any?, forKey key: String) {
        
        if key == "number_of_stories_to_show"{
            if let valueD = value as? String, let intValue = Int(valueD) {
                self.number_of_stories_to_show = intValue
            }
            
        }else if key == "scroll_speed_ms" {
            if let valueD = value as? Int {
                set_scroll_speed = valueD
            }
            
        }else if key == "limit_stories" {
            if let valueD = value as? Int {
                number_of_stories_to_show = valueD
            }
        }else if key == "theme"{
            theme = Theme(value: value)
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    
}



