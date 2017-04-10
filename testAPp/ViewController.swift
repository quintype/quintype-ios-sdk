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
      
//      Quintype.downloader.Download(url: "https://thequint-next.quintype.io/api/v1/stories") { (data) in
//    
//        print(data)
//        
//        }
    }

    
}

