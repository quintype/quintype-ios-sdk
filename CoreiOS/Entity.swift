//
//  File.swift
//  Pods
//
//  Created by Arjun P A on 03/07/17.
//
//

import Foundation

public class Entity:SafeJsonObject{
    
    public var name:String?
    public var id:NSNumber!
    public var link:String?
    public var images:[EntityPhoto]?
    
}
