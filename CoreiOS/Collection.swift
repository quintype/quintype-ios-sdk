//
//  Collection.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 24/04/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit


open class CoverImageMetadata:SafeJsonObject{
    open var width:NSNumber?
    open var height:NSNumber?
    open var mime_type:String?
}

open class CoverImage:SafeJsonObject{
    open var cover_image_url:String?
    open var cover_image_metadata:ImageMetaData?
    
    open var caption:String?
    open var cover_image_s3_key:String?
    
    override open func setValue(_ value: Any?, forKey key: String) {
        if key == "cover_image_metadata"{
            
            if let valued = value as? [String:AnyObject]{
                let image = ImageMetaData()
               
                
                if let width = valued["width"] as? NSNumber{
                    image.width = width
                }
                if let height = valued["height"] as? NSNumber{
                    image.height = height
                }
                if let focusPoint = valued["focus-point"] as? [NSNumber]{
                    image.focus_point = focusPoint
                }
                
                cover_image_metadata = image
                
            }
            
        }else{
            super.setValue(value, forKey: key)
        }
        
    }
}

open class ColectionMetaData:SafeJsonObject{
    
    open var sections:[Section] = []
    open var cover_image:CoverImage?
    open var caprion:String?
    open var cover_image_s3_key:String?
    open var design_template:DesignTemplate?
    
    open var parentSection:String?
    
    open var snapshot:[String] = []
    open var cover_image_metadata:ImageMetaData?
    
    override open func setValue(_ value: Any?, forKey key: String) {
        
        if (key == "section") || (key == "sections") {
            
            for  section in value as! [[String:AnyObject]]{
                let singleSection = Section()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleSection.setValuesForKeys(data )
                    self.sections.append(singleSection)
                })
            }
            
            if sections.count > 0 {
             self.parentSection = self.getParentSectionName(sectionId: sections[0].id?.intValue)
            }
            
            
        }else if key == "cover_image"{
            
            if let valued = value as? [String:AnyObject]{
                let coverImage = CoverImage()
                Converter.jsonKeyConverter(dictionaryArray: valued, completion: { (data) in
                    coverImage.setValuesForKeys(data)
                })
                
                self.cover_image = coverImage
            }
            
        }else if key == "design_template"{
            
            if let valued = value as? [String:AnyObject]{
                let designTemplate = DesignTemplate()
                
                designTemplate.setValuesForKeys(valued)
                self.design_template = designTemplate
            }
            
        }else if key == "snapshot"{
            if let valueD = value as? [String:Any],let body = valueD["body"] as? String{
                
                let newString = body.replacingOccurrences(of: "<p>", with: "")
                let array = newString.components(separatedBy: "</p>")
                
                self.snapshot = array.filter({!$0.isEmpty})
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    func getParentSectionName(sectionId:Int?) -> String? {
        guard let subSectionId =  sectionId else{
            return nil
        }
        
        guard let config = Quintype.publisherConfig ,config.sections.count > 0 else{
            return nil
        }
        
        let parentSections = config.sections.filter({$0.parent_id?.intValue == nil})
        let sectionFromId = config.sections.first(where: {$0.id?.intValue == subSectionId})
        
        if let _ = sectionFromId?.parent_id?.intValue {
            
            let parentSectionName = parentSections.first(where: {$0.id?.intValue == sectionFromId?.parent_id?.intValue})?.name?.lowercased()
            
            return parentSectionName
            
        }else{
            return sectionFromId?.name?.lowercased()
        }
        
        
    }
    
}


open class DesignTemplate:SafeJsonObject{
    open var name:String?
}

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
    open var metadata:ColectionMetaData?

    
    
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
        }else if key == "metadata"{
            
             metadata = ColectionMetaData()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.metadata?.setValuesForKeys(data)
            })
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


