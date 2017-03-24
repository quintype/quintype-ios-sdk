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
        
        Quintype.initWithBaseUrl(baseURL: "https://thequint-next.quintype.io")
        
        
        
        
        
//        let param:[String:[String:[String:Any]]] = [
//            
//            "requests":[
//                
//                "videos":["story-group": "stack-92",
//                          "limit": 10,
//                          "fields": "id,headline,slug,url,hero-image-s3-key,hero-image-metadata,first-published-at,last-published-at,alternative,published-at,author-name,author-id,sections,story-template,summary,metadata",
//                          "_type": "stories"
//                ]
//                
//            ]
//            
//            
//        ]
//        
//        Quintype.api.bulkCall(param: param, Success: { (data) in
//            
//            print(data)
//            
//        }) { (err) in
//            
//            print(err)
//        }
//        
        
        Quintype.api.collectionApiRequest(stack: "videos", Success: { (data) in
            
            print(data)
            
        }) { (err) in
            
            print(err)
            
        }
        
        
    }
    
    
    
}

