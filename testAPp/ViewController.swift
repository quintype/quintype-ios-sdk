//
//  ViewController.swift
//  testAPp
//
//  Created by Albin CR on 3/14/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Quintype


enum collectionTypes:String{
    
    case collection = "collection"
    case story = "story"
    
}

class ViewController: UIViewController {
    
    
    var storyCollection:[String:[Story]] = [:]
    
    var deepDive = 4
    var count = 0
    var bulkLimit = 5
    
    let bulkFields:[String] = ["id","headline","slug","url","hero-image-s3-key","hero-image-metadata","first-published-at","last-published-at","alternative","published-at","author-name","author-id","sections","story-template","summary","metadata"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Quintype.initWithBaseUrl(baseURL: "https://www.thequint.com")
        
        initCollectionCall(stack: "home",deepDive: 4)
        
    }
    
    func initCollectionCall(stack:String,deepDive:Int){
        
        Quintype.api.collectionApiRequest(stack: stack, cache: cacheOption.none, Success: { (data) in
            
            if let parsedData = self.parseCollectionData(data: data){
                
                self.collectionBulkCall(requestDict: parsedData)
                
            }
            
            
        }) { (errorMsg) in print( "error from collection call ")}
    }
    
    func parseCollectionData(data:Any?) -> [String:[String:[String:Any]]]? {
        
        
        if let collectionData = data as? CollectionModel{
            
            let collections = collectionData.items
            
            var outerDict:[String:[String:Any]] = [:]
            
            for (index,collection) in collections.enumerated(){
                
                var innerDict:[String:Any] = [:]
                
                if collection.type == collectionTypes.collection.rawValue{
                    
                    innerDict["limit"] = "\(self.bulkLimit)"
                    innerDict["slug"] = collection.slug ?? ""
                    innerDict["story-fields"] = self.bulkFields.joined(separator: ",")
                    innerDict["_type"] = collection.type ?? ""
                    
                    outerDict[collection.slug ?? ""] = innerDict
                    print(collection.name)
                    
                }else if collection.type == collectionTypes.story.rawValue{
                    
                    
                    print(collection.name)
                    //
                    collectionData.items.forEach({ (collectionItem) in
                        
                        if storyCollection[collectionData.name!] == nil {
                            
                            storyCollection[collectionData.name!] = [collectionItem.story!]
                            
                        }else{
                            storyCollection[collectionData.name!]?.append(collectionItem.story!)
                            
                        }
                    })
                    
                    
                }
            }
            let requestDict = ["requests": outerDict]
            
            return requestDict
            
            
            
        }else{
            return nil
        }
        
    }
    
    
    func collectionBulkCall(requestDict:[String:[String:[String:Any]]]){
        
        self.count = self.count + 1
        
        if count < 4 {
            
            Quintype.api.bulkCall(param: requestDict, cache: cacheOption.none, Success: { (data) in
                
                guard let someData = data as? [String:AnyObject] else {
                    return
                }
                
                guard let results = someData["results"] as? [String:AnyObject] else{
                    return
                }
                var mergedCollection:[CollectionModel] = []
                
                for (index, value) in Array(results.values).enumerated(){
                    
                    
                    print(value)
                    
                    ApiParser.collectionParser(data: value as? [String:AnyObject], completion: { (collection) in
                        print(collection)
                        
                        let keyArray = Array(results.keys)
//                        mergedCollection.
                        
                        if let parsedData = self.parseCollectionData(data: collection){
                            
                            
                            
            
                                self.collectionBulkCall(requestDict: parsedData)
                                
                      
                            
                            
                            
                        }
                        
                        
                    })
                }
                
                
                
            }, Error: { (error) in print("error from collection bulk call")})
            
        }else{
            print(storyCollection)
            return
        }
        
    }
    
    
    
}

