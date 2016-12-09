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
    
    
    var api:ApiService = ApiService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let necessaryStoryFields = ["updated-at","id", "hero-image-s3-key", "sections","cards", "headline","author-name", "created-at", "hero-image-caption","story-content-id", "tags", "hero-image-metadata", "story-template", "slug"]
        
        
        //        api.getRelatedStories(storyId: "2e30cea1-b063-4531-9cbd-4f8631e55f60",SectionId: nil, fields: nil){ (error, data) in
        //
        //            print(data!)
        //
        //            self.api.getStories(options: storiesOption.topStories, fields: nil, offset: nil, limit: nil, storyGroup: nil){ (error, data) in
        //
        //                print(data!)
        //
        //            }
        //
        //        }
        
        //        api.getCommentsForStory(storyId: "5051f448-9081-44c5-b249-bc191f496053") { (error, data) in
        //
        //            print(data!)
        //
        //
        //        }
        
        //        api.getStoryFromSlug(slug: "voices/2016/12/09/testing-photo-story-type"){ (error, data) in
        //
        //            print(data!)
        //
        //        }
        
        //        api.getBreakingNews(fields: necessaryStoryFields, limit: nil, offset: nil){ (error, data) in
        //
        //            print(data!)
        //
        //        }
        
        api.facebookLogin { (webView) in
            
            //        webView.delegate = self
            
            
            view.addSubview(webView)
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

