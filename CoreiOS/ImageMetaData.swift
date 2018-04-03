//
//  File.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class ImageMetaData:SafeJsonObject {
    
    public var width: NSNumber?
    public var height: NSNumber?
    public var focus_point: [NSNumber]?
    open var mime_type:String?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "focus_point" {
            
            focus_point?.append(value as! NSNumber)
            
        }
    }
}

