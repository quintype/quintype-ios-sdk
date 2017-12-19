//
//  Engagment.swift
//  Quintype
//
//  Created by Pavan Gopal on 12/4/17.
//

import Foundation

open class Engagement:SafeJsonObject{
    
    public var engagmentCount:Int = 0
    public var facebook:FacebookEngagement?
    public var shrubbery: ShrubberyEngagement?
    
    
    override open func setValue(_ value: Any?, forKey key: String) {
        
        if key == "facebook"{
            let facebookObj = FacebookEngagement()
            if let valueD = value as? [String:Any]{
                facebookObj.setValuesForKeys(valueD)
                self.facebook = facebookObj
                engagmentCount += self.facebook?.engagement?.intValue ?? 0
            }
        }else if key == "shrubbery"{
            let shrubberyObj = ShrubberyEngagement()
            
            if let valueD = value as? [String:Any]{
                shrubberyObj.setValuesForKeys(valueD)
                self.shrubbery = shrubberyObj
                engagmentCount += self.shrubbery?.views?.intValue ?? 0
            }
        }
        
        super.setValue(value, forKey: key)
        
    }
}

open class FacebookEngagement:SafeJsonObject{
    public  var engagement:NSNumber?
    public var shares: NSNumber?
    public var comments: NSNumber?
    public var reactions:NSNumber?
    
}

open class ShrubberyEngagement:SafeJsonObject{
    public var views:NSNumber?
}
