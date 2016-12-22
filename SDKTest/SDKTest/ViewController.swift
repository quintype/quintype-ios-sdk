//
//  ViewController.swift
//  SDKTest
//
//  Created by Albin CR on 12/2/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import UIKit
import CoreiOS

class ViewController: UIViewController{
    
    
    let api = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        api.getPublisherConfig(cache: cacheOption.loadOldCacheAndReplaceWithNew) { (err, data) in
        //            //print(data)
        //        }
        //        api.getStories(options: storiesOption.storyGroupInSection(storyGroupName: "top", sectionName: "top"), fields: nil, offset: nil, limit: nil, storyGroup: nil, cache: cacheOption.loadOldCacheAndReplaceWithNew) { (error, data) in
        //            //print(data)
        //        }
        //        api.getStoryFromId(storyId: "ae13b6cd-61b7-4e27-a9ac-0f38ac7daff3", cache: cacheOption.cacheToMemoryWithTime(min: 30)) { (error, data) in
        //            //print(data)
        //        }
        //        api.getRelatedStories(storyId: "ae13b6cd-61b7-4e27-a9ac-0f38ac7daff3", SectionId: nil, fields: nil, cache: cacheOption.cacheToMemoryWithTime(min: 30)) { (error, data) in
        //            //print(data)
        //        }
        //        api.getCommentsForStory(storyId: "ae13b6cd-61b7-4e27-a9ac-0f38ac7daff3", cache: cacheOption.loadOldCacheAndReplaceWithNew) { (error, data) in
        //            //print(data)
        //        }
        //        api.getStoryFromSlug(slug: "/sports/2016/11/15/cricket-4", cache: cacheOption.cacheToMemoryWithTime(min: 20)) { (error, data) in
        //            //print(data)
        //        }
        
        //       Quintype.getPublisherConfig(options: publisherOption.all) { (data) in
        //               //print(data)
        //        }
        

        Quintype.analytics
    }
    
}
