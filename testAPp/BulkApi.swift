//
//  BulkApi.swift
//  Quintype
//
//  Created by Albin.git on 7/5/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import Quintype

enum collectionTypes:String{
    
    case collection = "collection"
    case story = "story"
    
}

open class BulkApi{
    
    var deepDive:Int = 1
    var bulkLimit:Int = 1
    var bulkFields:[String] = []
    var storyCollection:[String:[Story]] = [:]
    var count = 1
    
    
    public func BulkCall(Slug:String,deepDive:Int,bulkFields:[String],bulkLimit:Int,cache:cacheOption,Error:@escaping (String)->(),Success:@escaping ([String:[Story]]) -> ()){
        self.deepDive = deepDive
        self.bulkLimit = bulkLimit
        self.bulkFields = bulkFields
        
        initCollectionCall(stack: Slug, cache: cache, Error: { (error) in
            
            Error(error)
            
        }) { (storyArray) in
            
            Success(storyArray)
            
        }
        
    }
    
    func initCollectionCall(stack:String,cache:cacheOption,Error:@escaping (String)->(),Success:@escaping ([String:[Story]]) -> ()){
        
        Quintype.api.collectionApiRequest(stack: stack, cache: cache, Success: { (data) in
            
            if let parsedData = self.parseCollectionData(data: data){
                
                self.collectionBulkCall(requestDict: parsedData, Error: { (error) in
                    
                    Error(error)
                    
                }, Success: { (storyArray) in
                    
                    Success(storyArray)
                    
                })
                
            }
            
            
        }) { (errorMsg) in print( "error from collection call ")}
    }
    
    func parseCollectionData(data:Any?) -> [String:[String:[String:Any]]]? {
        
        
        if let collectionData = data as? CollectionModel{
            
            let collections = collectionData.items
            var outerDict:[String:[String:Any]] = [:]
            
            for (_,collection) in collections.enumerated(){
                
                var innerDict:[String:Any] = [:]
                
                if collection.type == collectionTypes.collection.rawValue{
                    
                    innerDict["limit"] = "\(self.bulkLimit)"
                    innerDict["slug"] = collection.slug ?? ""
                    innerDict["story-fields"] = self.bulkFields.joined(separator: ",")
                    innerDict["_type"] = collection.type ?? ""
                    outerDict[collection.slug ?? ""] = innerDict
                    
                }else if collection.type == collectionTypes.story.rawValue{
                    
                    
                    if storyCollection[collection.name!] == nil {
                        
                        storyCollection[collection.name!] = [collection.story!]
                        
                    }else{
                        storyCollection[collection.name!]?.append(collection.story!)
                        
                    }
                    
                }
            }
            let requestDict = ["requests": outerDict]
            
            return requestDict
            
        }else{
            return nil
        }
        
    }
    
    
    func collectionBulkCall(requestDict:[String:[String:[String:Any]]],internalCall:Bool = false,Error:@escaping (String)->(),Success:@escaping ([String:[Story]])->()){
        
        self.count = self.count + 1
        
        if count < deepDive {
            
            Quintype.api.bulkCall(param: requestDict, cache: cacheOption.none, Success: { (data) in
                
                guard let someData = data as? [String:AnyObject] else {
                    return
                }
                
                guard let results = someData["results"] as? [String:AnyObject] else{
                    return
                }
                
                let mergedCollection:CollectionModel = CollectionModel()
                
                for (_,value) in Array(results.values).enumerated(){
                    
                    ApiParser.collectionParser(data: value as? [String:AnyObject], completion: { (collection) in
                        
                        for (_,item) in collection.items.enumerated(){
                            
                            if item.type == collectionTypes.collection.rawValue{
                                
                                mergedCollection.items.append(item)
                                
                            }else if item.type == collectionTypes.story.rawValue{
                                
                                
                                if self.storyCollection[collection.name!] == nil {
                                    
                                    self.storyCollection[collection.name!] = [item.story!]
                                    
                                }else{
                                    
                                    self.storyCollection[collection.name!]?.append(item.story!)
                                    
                                }
                            }
                        }
                    })
                }
                
                if requestDict["requests"]?.count == 0 || mergedCollection.items.count == 0{
                    
                    if internalCall{
                        Success(self.storyCollection)
                    }
                    return
                    
                }
                
                //TODO:- just parse data needed
                if let parsedData = self.parseCollectionData(data: mergedCollection){
                    
                    self.collectionBulkCall(requestDict: parsedData,internalCall: true, Error: { (error) in
                        
                    }, Success: { (data) in
                            Success(self.storyCollection)
                    })
                    
                }
                
            }, Error: { (error) in print("error from collection bulk call")})
            
        }else{
            
            Success(self.storyCollection)
            
        }
    }
    
    
}
