//
//  Collection.swift
//  Quintype
//
//  Created by Albin.git on 7/3/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation

open class Collection: SafeJsonObject {
    
    var id:NSNumber?
    var slug:String?
    var summary:String?
    var total_count:NSNumber?
    var automated:NSNumber?
    var updated_at:NSNumber?
    var created_at:NSNumber?
    var template:String?
    var items:[CollectionItem] = []
    var name:String?
    
    override open func setValue(_ value: Any?, forKey key: String) {
        if key == "items"{
            
            for itemDict in value as? [[String:AnyObject]] ?? []{
                let collectionItem = CollectionItem()
                Converter.jsonKeyConverter(dictionaryArray: itemDict, completion: { (mappedKeyValues) in
                    collectionItem.setValuesForKeys(mappedKeyValues)
                    if collectionItem.type ?? "" == "story"{
                        collectionItem.slug = self.slug
                    }
                    self.items.append(collectionItem)
                })
            }
        }
            
        else{
            super.setValue(value, forKey: key)
        }
        
    }
    
}

open class CollectionItem:SafeJsonObject{
    
    var id:NSNumber?
    var name:String?
    var slug:String?
    var template:String?
    var type:String?
    var collection:Collection?
    var story:Story?
    
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
  
}
