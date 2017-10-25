//
//  Collection.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 24/04/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit

open class CollectionModel: SafeJsonObject {
    
    open var id:NSNumber?
    open var slug:String?
    open var summary:String?
    open var total_count:NSNumber?
    open var automated:NSNumber?
    open var updated_at:NSNumber?
    open var created_at:NSNumber?
    open var template:String?
    open var items:[CollectionItem] = []
    open var name:String?
    
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
    open func copy(with zone: NSZone? = nil) -> Any {
        let collection =  CollectionModel()
        collection.id = id
        collection.slug = slug
        collection.summary = summary
        collection.total_count = total_count
        collection.automated = automated
        collection.updated_at = updated_at
        collection.created_at = created_at
        collection.template = template
        collection.items = items
        collection.name = name
        return collection
    }
    
}


