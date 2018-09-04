//
//  CollectionBulkManager.swift
//  Quintype
//
//  Created by Pavan Gopal on 10/25/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//


import UIKit
import Foundation

open class CollectionBulkManager: NSObject {
    
   open static var bulkNecessaryFields:Array<String> = ["id","headline","slug","url","hero-image-s3-key","hero-image-metadata","first-published-at","last-published-at","alternative","published-at","author-name","author-id","sections","story-template","summary","metadata"]
    
    
   public  var bulkLimit:Int = 5
   public var keys:Dictionary<String, String> = [:]
    
    public var _slug:String
    public var resultantCollections:[String:CollectionModel]?
    public var page:Page
    
    public init(slug:String, startImmediately:Bool,storyLimit:Int=4) {
        
        
        self.bulkLimit = storyLimit
        
        _slug = slug
        page = Page.init(offsetPara: 0, limitPara: storyLimit)
        
        super.init()
        startImmediately ? startFetch() : ()
    }
    
    public typealias COMPLETION_HANDLER = (CollectionModel?, Error?) -> ()
    open var completion:COMPLETION_HANDLER?
    
    open func startFetch(){
        
        
        if  page.status == Page.PAGING_STATUS.PAGING || page.status == Page.PAGING_STATUS.LAST_PAGE{
            return
        }
        
        if page.status == Page.PAGING_STATUS.ERRORED{
            page.minus()
        }
        
        page.status = Page.PAGING_STATUS.PAGING
        page.kick()
        
        var necessaryFields = CollectionBulkManager.bulkNecessaryFields//.joined(separator: ",") as NSString
        
        if _slug == "explainers" {
            necessaryFields.append("cards")
        }
        
        let fields = necessaryFields.joined(separator: ",") as NSString
        
        let param:[String:AnyObject] = ["story-fields": fields, "limit":NSNumber.init(value: page.limit), "offset":NSNumber.init(value: page.offset)]
        
        Quintype.api.collectionApiRequest(stack: _slug, cache: cacheOption.none,param: param,Success: { (collection) in
            
            if let collectiond = collection as? [String:AnyObject]{
                ApiParser.collectionParser(data: collectiond, completion: { (collection, error) in
                    
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
                  
                    })
                })
            }
        }) { (error) in
            self.page.status = Page.PAGING_STATUS.ERRORED
            self.completion?(nil, NSError.init(domain: error ?? "", code: -1, userInfo: nil))
        }
    }
    
    
    func recursiveBulkRequest(collectionItems:[CollectionItem], completion:@escaping (_ collections:[String:CollectionModel]) -> Void){
        
        self.makeGetBulkRequest(collectionItems: collectionItems) { (collectionsPara) in
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
                
                for (slugKey,value) in collections{
                    
                    var parentSlugKey = slugKey
                    
                    while self.keys[parentSlugKey] != nil{
                        if parentSlugKey == self.keys[parentSlugKey]!{
                            break
                        }
                        
                        parentSlugKey = self.keys[parentSlugKey]!
                    }
                    
                    if self.resultantCollections != nil && self.resultantCollections![parentSlugKey] != nil{
                        
                        let index = self.resultantCollections![parentSlugKey]!.items.index(where: {$0.slug == value.slug ?? "" && $0.type == "collection" })
                        var parentSlug:String?
                        var parentCollectionName:String?
                        if index != nil{
                            parentSlug = self.resultantCollections![parentSlugKey]!.items[index!].slug
                            parentCollectionName = self.resultantCollections![parentSlugKey]!.items[index!].name
                            self.resultantCollections![parentSlugKey]!.items.remove(at: index!)
                        }
                        value.items = value.items.map({ (item) -> CollectionItem in
                            item.slug = parentSlug ?? parentSlugKey
                            item.name = parentCollectionName
                            return item
                        })
                        
                        self.resultantCollections![parentSlugKey]!.items = value.items +  self.resultantCollections![parentSlugKey]!.items
                        self.resultantCollections![parentSlugKey]!.items = Array(self.resultantCollections![parentSlugKey]!.items.prefix(self.bulkLimit))
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
    
    func makeGetBulkRequest(collectionItems:[CollectionItem], completion:@escaping (_ collections:[String:CollectionModel]) -> Void){
        
        let filteredCollections = collectionItems.filter({$0.type ?? "" == "collection"})
        
        
        var innerDict:Dictionary<String,Any> = [:]
        
        for (index,item) in filteredCollections.enumerated(){
            
            let indexToUse = index + 1
            let slugToUse = item.slug//?.replacingOccurrences(of: "---", with: "-")
            
            innerDict["slug\(indexToUse)"] = slugToUse
            innerDict["limit\(indexToUse)"] = "\(8)"
            
            let templet = item.template ?? ""
            
            if templet == "quint-lens" || templet == "photos" || templet == "deqoded"{
                innerDict["cards\(indexToUse)"] = "\(true)"//if you need cards as well
            }
//            else{
//                innerDict["card\(indexToUse)"] = "\(false)"//cards not required you need cards as well
//            }
            
            
        }
        
        Quintype.api.getBulkCollectionCall(queryParams: innerDict, cacheOption: .none, Success: { (bulkCallResponse) in
            ApiParser.collectionBulkParser(data: bulkCallResponse, completion: { (collectionArray, error) in
                completion(collectionArray)
            })
        }) { (errorMessage) in
            print(errorMessage ?? "Error message is nil")
        }
    }
    
}









