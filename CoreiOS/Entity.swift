//
//  File.swift
//  Pods
//
//  Created by Arjun P A on 03/07/17.
//
//

import Foundation
import Unbox

open class Entity:SafeJsonObject, Unboxable{
    
    public var name:String?
    public var id:Int!
    public var type:String!
    
    
    required public override init() {
        super.init()
    }
    
    public required init(unboxer: Unboxer) throws{
        self.id =  unboxer.unbox(key: "id")
        self.name =  unboxer.unbox(key: "name")
        self.type = unboxer.unbox(key: "type")
    }
    
}
