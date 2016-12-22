//
//  menuMeta.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class MenuMeta:SafeJsonObject{
    
    public var color:String?
    public var link:String?
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.color = aDecoder.decodeObject(forKey: "color") as? String
        self.link = aDecoder.decodeObject(forKey: "color") as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(color, forKey: "color")
        aCoder.encode(link, forKey: "link")
    }
    
    
    
}
