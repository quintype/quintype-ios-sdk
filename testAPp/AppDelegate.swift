//
//  AppDelegate.swift
//  testAPp
//
//  Created by Albin CR on 3/14/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Quintype

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Quintype.initWithBaseUrl(baseURL: "https://www.thequint.com")
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
        Quintype.downloader.tellAppDelegateHandleEventsForBackgroundURLSessionIsCompleted = completionHandler
 
    }

}

