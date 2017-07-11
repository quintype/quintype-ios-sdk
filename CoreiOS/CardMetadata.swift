//
//  CardMetadata.swift
//  Pods
//
//  Created by Arjun P A on 04/07/17.
//
//

import Foundation

public class CardMetadata:SafeJsonObject{
    public var storyAttributes:[String:AnyObject]?
    
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "attributes"{
            if let valued = value as? [String:AnyObject]{
                self.storyAttributes = valued
            }
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
}
