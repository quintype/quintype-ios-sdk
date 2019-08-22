//
//  SectionMeta.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class SectionMeta:SafeJsonObject{
    
    public var id:NSNumber?
    public var name:String?
    public var display_name:String?
    public var slug:String?
    public var parent_id:NSNumber?
    public var collection:SectionMeta?
    override public func setValue(_ value: Any?, forKey key: String)
    {
        if key == "collection"
        {
            if let valued = value as? [String:AnyObject]
            {
                let storyMeta = SectionMeta()
                storyMeta.setValuesForKeys(valued)
                self.collection = storyMeta
            }
        }
        else
        {
            super.setValue(value, forKey: key)
        }
    }
}
