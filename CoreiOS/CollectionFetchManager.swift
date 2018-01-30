//
//  CollectionFetchManager.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 24/04/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Foundation
open class CollectionFetchManager: NSObject {
    
    static var bulkNecessaryFields:Array<String> = ["id","headline","slug","url","hero-image-s3-key","hero-image-metadata","first-published-at","last-published-at","alternative","published-at","author-name","author-id","sections","story-template","summary","metadata"]
    
    
    
    var bulkLimit:Int = 5
    var keys:Dictionary<String, String> = [:]
    var onlyCollection:Bool = false
    fileprivate var _slug:String
    fileprivate var resultantCollections:[String:CollectionModel]?
    fileprivate var page:Page
    
    
    
    public init(slug:String, startImmediately:Bool,storyLimit:Int=4, onlyCollection:Bool=false) {
        
        
        self.bulkLimit = storyLimit
        self.onlyCollection = onlyCollection
        _slug = slug
        page = Page.init(offsetPara: 0, limitPara: storyLimit)
        
        super.init()
        startImmediately ? startFetch() : ()
    }
    
    public typealias COMPLETION_HANDLER = (CollectionModel?, Error?) -> ()
    open var completion:COMPLETION_HANDLER?
    
    public func startFetch(){
        
        if  page.status == Page.PAGING_STATUS.PAGING || page.status == Page.PAGING_STATUS.LAST_PAGE{
            return
        }
        
        if page.status == Page.PAGING_STATUS.ERRORED{
            page.minus()
        }
        
        page.status = Page.PAGING_STATUS.PAGING
        page.kick()
        let param:[String:AnyObject] = ["story-fields":CollectionFetchManager.bulkNecessaryFields.joined(separator: ",") as NSString, "limit":NSNumber.init(value: page.limit), "offset":NSNumber.init(value: page.offset)]
        Quintype.api.collectionApiRequest(stack: _slug, cache: cacheOption.none,param: param,Success: { (collection) in
            
            if let collectiond = collection as? [String:AnyObject]{
                ApiParser.collectionParser(data: collectiond, completion: { (collection, error) in
                    print(collection)
                    self.resultantCollections = nil
                    self.keys.removeAll()
                    if !self.onlyCollection{
                        self.recursiveBulkRequest(collectionItems: collection.items, completion: { (collectionMapping) in
                            
                            collection.items = collection.items.map({ (item) -> CollectionItem in
                                if item.type ?? "" == "collection"{
                                    
                                    item.collection = collectionMapping[item.slug ?? ""]
                                    
                                }
                                
                                
                                return item
                            })
                            if collection.items.count == 0{
                                self.page.status = Page.PAGING_STATUS.LAST_PAGE
                            }
                            else{
                                self.page.status = Page.PAGING_STATUS.NOT_PAGING
                            }
                            self.completion?(collection, nil)
                            
                        })
                    }
                    else{
                        
                        if collection.items.count == 0{
                            self.page.status = Page.PAGING_STATUS.LAST_PAGE
                        }
                        else{
                            self.page.status = Page.PAGING_STATUS.NOT_PAGING
                        }
                        self.completion?(collection, nil)
                        
                    }
                    
                })
            }
        }) { (error) in
            self.page.status = Page.PAGING_STATUS.ERRORED
            self.completion?(nil, NSError.init(domain: error ?? "", code: -1, userInfo: nil))
        }
    }
    
    
    func recursiveBulkRequest(collectionItems:[CollectionItem], completion:@escaping (_ collections:[String:CollectionModel]) -> Void){
        
        self.bulkRequestMake(collectionItems: collectionItems) { (collectionsPara) in
            let collections = collectionsPara
            
            completion(collectionsPara)
            
        }
    }
    
    func bulkRequestMake(collectionItems:[CollectionItem], completion:@escaping (_ collections:[String:CollectionModel]) -> Void){
        
        let filteredCollections = collectionItems.filter({$0.type ?? "" == "collection"})
        
        var outerDict:Dictionary<String,Dictionary<String,Any>> = [:]
        
        for (_,item) in filteredCollections.enumerated(){
            var innerDict:Dictionary<String,Any> = [:]
            
            innerDict["limit"] = "\(bulkLimit)"
            innerDict["slug"] = item.slug ?? ""
            innerDict["story-fields"] = CollectionFetchManager.bulkNecessaryFields.joined(separator: ",")
            innerDict["_type"] = item.type ?? ""
            
            outerDict[item.slug ?? ""] = innerDict
        }
        
        let requestDict = ["requests": outerDict]
        Quintype.api.bulkCall(param: requestDict, cache: .none, Success: { (result) in
            
            // print(result)
            ApiParser.collectionBulkParser(data: result, completion: { (collections, error) in
                
                completion(collections)
            })
            
            
        }) { (error) in
            
        }
        
    }
    
}

