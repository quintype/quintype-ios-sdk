//
//  DataController.swift
//  SDKTest
//
//  Created by Albin CR on 12/21/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import UIKit
import CoreiOS

class DataController: UIViewController {
    let an = Quintype.analytics
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        an.trackPageViewSectionVisit(section: "games")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
