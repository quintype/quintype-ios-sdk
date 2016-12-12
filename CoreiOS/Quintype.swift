//
//  Quintype.swift
//  CoreiOS
//
//  Created by Albin CR on 12/12/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

open class Quintype{
    
    open static func initWithBaseUrl(baseURL: String!) {
        
        
        let regExp = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regExp])
        let status = predicate.evaluate(with: baseURL)
        
        if !status{
            print("The Base URL Entered Is Wrong")
        }
        
    }
  
}
