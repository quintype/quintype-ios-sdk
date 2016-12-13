//
//  SafeJsonObject.swift
//  CoreiOS
//
//  Created by Albin CR on 12/5/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

// MARK: Json parser classs for safely paring json 

public class SafeJsonObject: NSObject {
   
    override public func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            print(key ,":", value)
            super.setValue(value, forKey: key)
        }
    }
    
}
