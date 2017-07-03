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
        Quintype.initWithBaseUrl(baseURL: "https://www.thequint.com")

        
     Quintype.api.collectionApiRequest(stack: "home", cache: cacheOption.none, Success: { (data) in
        
        let collections = data as? CollectionModel
        
    
        
     }) { (errorMsg) in
        
        print(errorMsg)
        
        
        
    }

    
}

