//
//  CollectionFetchManager.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 24/04/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit
import Foundation
import Quintype

open class CollectionFetchManager: NSObject {
    
 
    
    
    let bulkLimit:Int = 5
    fileprivate var _slug:String
    static var bulkNecessaryFields:Array<String> = ["id","headline","slug","url","hero-image-s3-key","hero-image-metadata","first-published-at","last-published-at","alternative","published-at","author-name","author-id","sections","story-template","summary","metadata"]
    fileprivate var resultantCollections:[String:CollectionModel]?
    fileprivate var page:Page
    var keys:Dictionary<String, String> = [:]
    public init(slug:String, startImmediately:Bool) {
        _slug = slug
        page = Page.init(offsetPara: 0, limitPara: 10)
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
                        print(collection)
                        
                    })
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
            
            
            if self.resultantCollections == nil{
                self.resultantCollections = collections
                
                var items:[CollectionItem] = []
                let filtered = Array(collections.values).filter({ (oneCollection) -> Bool in
                    if oneCollection.items.first == nil{
                        return false
                    }
                    let flag = oneCollection.items.first!.type ?? "" == "collection"
                    if flag{
                        items.append( oneCollection.items.first!)
                    }
                    return flag
                })
                
                if filtered.count == 0{
                    
                    completion(self.resultantCollections!)
                    return
                }
                for filter in filtered{
                    //    self.keys[filter.slug!] = filter.items.first!.slug!
                    self.keys[filter.items.first!.slug!] = filter.slug!
                }
                if filtered.count > 0 {
                    self.recursiveBulkRequest(collectionItems: items, completion: completion)
                    
                }
            }
            else{
                
                for (key,value) in collections{
                    
                    var keyCopy = key
                    
                    while self.keys[keyCopy] != nil{
                        keyCopy = self.keys[keyCopy]!
                    }
                    if self.resultantCollections != nil && self.resultantCollections![keyCopy] != nil{
                        
                        let index = self.resultantCollections![keyCopy]!.items.index(where: {$0.slug == value.slug ?? "" && $0.type == "collection" })
                        var parentSlug:String?
                        var parentCollectionName:String?
                        if index != nil{
                            parentSlug = self.resultantCollections![keyCopy]!.items[index!].slug
                            parentCollectionName = self.resultantCollections![keyCopy]!.items[index!].name
                            self.resultantCollections![keyCopy]!.items.remove(at: index!)
                        }
                        value.items = value.items.map({ (item) -> CollectionItem in
                            item.slug = parentSlug ?? keyCopy
                            item.name = parentCollectionName
                            return item
                        })
                        
                        self.resultantCollections![keyCopy]!.items = value.items +  self.resultantCollections![keyCopy]!.items
                        self.resultantCollections![keyCopy]!.items = Array(self.resultantCollections![keyCopy]!.items.prefix(self.bulkLimit))
                    }
                    
                }
                
                var items:[CollectionItem] = []
                let filtered = Array(collections.values).filter({ (oneCollection) -> Bool in
                    if oneCollection.items.first == nil{
                        return false
                    }
                    let flag = oneCollection.items.first!.type ?? "" == "collection"
                    if flag{
                        items.append( oneCollection.items.first!)
                    }
                    return flag
                })
                for filter in filtered{
                    //  self.keys[filter.slug!] = filter.items.first!.slug!
                    self.keys[filter.items.first!.slug!] = filter.slug!
                }
                
                if filtered.count > 0 {
                    self.recursiveBulkRequest(collectionItems: items, completion: completion)
                    
                }
                else{
                    completion(self.resultantCollections!)
                    self.keys.removeAll()
                    self.resultantCollections = nil
                    return
                    
                }
            }
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
