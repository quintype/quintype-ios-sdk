//
//  Storage.swift
//  CoreiOS
//
//  Created by Albin CR on 12/12/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

open class Storage{
    //Storage class for storing value thru shared instance
    
    // MARK: - Shared instance -
    open static let sharedStorage = Storage()
    
    private var baseUrl:String?
    
    private init(){}
    
    // MARK: - Get base url -
    public func getBaseUrl() -> String?{
        
        if baseUrl == nil{
            
            precondition(false, "               SDK Is Not Initialized In AppDelegate Base URL not found.               ")
        }
        
        return baseUrl
    }
    
    // MARK: - Store base url -
    public func storageBaseURL(baseURL:String){
        
        self.baseUrl = baseURL
    }
    
    
}
