//
//  Storage.swift
//  CoreiOS
//
//  Created by Albin CR on 12/12/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

open class Storage{
    
    
    
    // MARK: Shared instance
    open static let sharedStorage =  Storage()
    
    var baseUrl:String
    
    
    public init(baseURL:String) {
        baseUrl = baseURL
    }
    
    public func getBaseUrl() -> String{
        
        return baseUrl
    }
    
    
}
