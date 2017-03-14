//
//  ViewController.swift
//  testAPp
//
//  Created by Albin CR on 3/14/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Quintype

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Quintype.initWithBaseUrl(baseURL: "http://www.gaonconnection.com")
        
        
        
        
        
        
        
        Quintype.api.getPublisherConfig(cache: cacheOption.cacheToDiskWithTime(min: 5), Success: { (config) in
            
            print(config)
            
            
        }) { (err) in
            
            print(err)
            
        }
        
        
        
        
        
        
        
        
        
        
    }



}

