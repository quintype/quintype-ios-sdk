//
//  SafeJsonObject.swift
//  CoreiOS
//
//  Created by Albin CR on 12/5/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

// MARK: Json parser classs for safely paring json 
@objcMembers
open class SafeJsonObject: NSObject {
   
override open func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}
