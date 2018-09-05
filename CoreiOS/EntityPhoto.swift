//
//  EntityPhoto.swift
//  Pods
//
//  Created by Arjun P A on 03/07/17.
//
//

import Foundation

public class EntityPhoto: SafeJsonObject {
    public var key:String?
    public var url:String?
    public var caption:String?
    public var metadata:ImageMetaData?
}
