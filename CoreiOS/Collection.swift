//
//  Collection.swift
//  Quintype
//
//  Created by Albin.git on 7/3/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation

open class CollectionModel: SafeJsonObject {
    
    public var id:NSNumber?
    public var slug:String?
    public var summary:String?
    public var total_count:NSNumber?
    public  var automated:NSNumber?
    public  var updated_at:NSNumber?
    public  var created_at:NSNumber?
    public var template:String?
    public var items:[CollectionItem] = []
    public var name:String?
    
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
    
    public var id:NSNumber?
    public var name:String?
    public var slug:String?
    public var template:String?
    public var type:String?
    public var collection:CollectionModel?
    public var story:Story?
    
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
