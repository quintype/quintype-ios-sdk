//
//  Menu.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Menu:SafeJsonObject{
    
    public var updated_at:NSNumber?
    public var tag_name:String?
    public var publisher_id:NSNumber?
    public var item_id:NSNumber?
    public var rank:NSNumber?
    public var title:String?
    public var item_type:String?
    public var section_slug:String?
    public var id:NSNumber?
    public var parent_id:NSNumber?
    public var created_at:NSNumber?
    public var section_name:String?
    public var data:MenuMeta?
    public var url:String?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        
        if key == "data"{
            
            data = MenuMeta()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.data?.setValuesForKeys(value as! [String: AnyObject])
                
            })
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    
    
}
