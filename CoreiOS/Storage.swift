//
//  Storage.swift
//  CoreiOS
//
//  Created by Albin CR on 12/12/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

open class Storage{
    
    var baseUrl:String
    
    // MARK: Shared instance
    open static var sharedStorage: Storage!
    
    
   public init(baseURL:String) {
        baseUrl = baseURL
    }
    
    public func getBaseUrl() -> String{
        
        return baseUrl
    }
    
    
}
