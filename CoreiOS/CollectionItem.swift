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
    
    override open func setValue(_ value: Any?, forKey key: String) {
        
        if key == "story"{
            let datad = ["story":value]
            ApiParser.storyParser(data: datad as [String : AnyObject]?, completion: { (story) in
                self.story = story
            })
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
