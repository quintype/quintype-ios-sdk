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
    public var metaAttributes: MetaDataAttributes?
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "attributes"{
            
            let attributes = MetaDataAttributes()
            
            if let valued = value as? [String:AnyObject]{
                
                self.storyAttributes = valued
                
                attributes.setValuesForKeys(valued)
                
                self.metaAttributes = attributes
            }
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
}

public class MetaDataAttributes:SafeJsonObject{
    
    public var key_event : Bool?
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "key-event"{
            if let unwrappedValue = value as? Bool{
                self.key_event = unwrappedValue
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
}
