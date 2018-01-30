//
//  CollectionRevealFetchManager.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 04/05/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit

open class CollectionRevealFetchManager: NSObject {
    
    let bulkLimit:Int = 5
    fileprivate var resultantCollections:[String:CollectionModel]?
    fileprivate var filteredOutStories:[CollectionModel] = []
    var keys:Dictionary<String, String> = [:]
    var _slug:String
    fileprivate var _currentItems:[CollectionItem] = []
    public typealias COMPLETION_HANDLER = ([CollectionModel], Error?) -> ()
    open var completion:COMPLETION_HANDLER?
    fileprivate var _page:Page?
    fileprivate var _originalOffset:Int = 0
    fileprivate var page:Page!{
        get{
            return _page!
        }
        set{
            _page = newValue
        }
    }
    fileprivate var collectionPager:CollectionPager!{
        get{
            return _collectionPager!
        }
        set{
            _collectionPager = newValue
        }
    }
    fileprivate var _collectionPager:CollectionPager?
    public init(slug:String, originalOffset:Int = 0) {
        
        _slug = slug
        _originalOffset = originalOffset
        super.init()
    }
    
    public func reset(){
        resultantCollections?.removeAll()
        keys.removeAll()
        collectionPager.reset()
        resultantCollections = nil
    }
    
    public func pageNext(){
        
        if _page != nil && (page.status == .LAST_PAGE || page.status == .PAGING){
            return
        }
        
        
        initializePage(offset:0)
        initialieCollectionPager(offset:0)
        collectionPager.pageNext()
        collectionPager.completion = {collection, error in
            
            self.resultantCollections = nil
            self.keys.removeAll()
            
            let areThereCollections =  collection.items.filter({$0.type == "collection"})
            if areThereCollections.count == 0{
                self.completion?([collection], nil)
            }
            self._currentItems = collection.items
            self.recursiveBulkRequest(collectionItems: collection.items, completion: { (collectionMapping) in
                
                let allValues = Array(collectionMapping.values)
                
                var sortedCollections  = allValues.sorted(by: { (firstCollection, secondCollection) -> Bool in
                    let firstIndex = self._currentItems.index(where: {$0.slug == firstCollection.slug})
                    let secondIndex = self._currentItems.index(where: {$0.slug == secondCollection.slug})
                    if firstIndex != nil && secondIndex != nil{
                        return firstIndex! < secondIndex!
                    }
                    return false
                })
                
                sortedCollections = sortedCollections.map({ (collectionIn) -> CollectionModel in
                    collectionIn.items = Array(collectionIn.items.prefix(self.bulkLimit))
                    return collectionIn
                })
                
                self.page.status = Page.PAGING_STATUS.NOT_PAGING
                DispatchQueue.main.async(execute: {
                    self.completion?(sortedCollections, nil)
                })
            })
        }
        
    }
    
    func initialieCollectionPager(offset:Int){
        if _collectionPager == nil{
            _collectionPager = CollectionPager.init(slug: _slug, offset: offset)
        }
    }
    
    func initializePage(offset:Int){
        if _page == nil{
            _page = Page.init(offsetPara:offset, limitPara: 5)
        }
    }
    
    func recursiveBulkRequest(collectionItems:[CollectionItem], completion:@escaping (_ collections:[String:CollectionModel]) -> Void){
        
        self.bulkRequestMake(collectionItems: collectionItems) { (collections) in
            if self.resultantCollections == nil{
                self.resultantCollections = collections
                
                var items:[CollectionItem] = []
                let filtered = Array(collections.values).filter({ (oneCollection) -> Bool in
                    if oneCollection.items.first == nil{
                        return false
                    }
                    var flag:Bool = false
                    let filtered = oneCollection.items.filter({$0.type ?? "" == "collection"})
                    if filtered.count > 0{
                        flag = true
                        items.append(contentsOf: filtered)
                    }
                    return flag
                })
                
                if filtered.count == 0{
                    completion(self.resultantCollections!)
                    return
                }
                for filter in filtered{
                    for item in filter.items{
                        self.keys[item.slug!] = filter.slug!
                    }
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
                        if index != nil{
                            self.resultantCollections![keyCopy]!.items.insert(contentsOf: value.items, at: index!)
                        }
                        
                        //  self.resultantCollections![keyCopy]!.items = value.items +  self.resultantCollections![keyCopy]!.items
                    }
                    
                }
                //prepare datasource for next bulk
                
                var items:[CollectionItem] = []
                let filtered = Array(collections.values).filter({ (oneCollection) -> Bool in
                    if oneCollection.items.first == nil{
                        return false
                    }
                    var flag:Bool = false
                    let filtered = oneCollection.items.filter({$0.type ?? "" == "collection"})
                    if filtered.count > 0{
                        flag = true
                        items.append(contentsOf: filtered)
                    }
                    return flag
                })
                for filter in filtered{
                    for item in filter.items{
                        self.keys[item.slug!] = filter.slug!
                    }
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
            innerDict["fields"] = CollectionFetchManager.bulkNecessaryFields.joined(separator: ",")
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
            self.page.status = Page.PAGING_STATUS.ERRORED
        }
        
    }
    
    
}
