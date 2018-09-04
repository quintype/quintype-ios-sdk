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
    public var is_pinned : Bool?
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "key-event"{
            if let unwrappedValue = value as? Bool{
                self.key_event = unwrappedValue
            }
        }else if key == "is-pinned"{
            if let unwrappedValue = value as? Bool{
                self.is_pinned = unwrappedValue
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
}
