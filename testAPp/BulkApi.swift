//
//  CollectionSettrt.swift
//  CoreApp-iOS
//
//  Created by Albin.git on 7/11/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import Quintype
import UIKit

protocol CollectionListLayoutDelegate:class {
    func didFetchRenderableCollections(renderables:[RenderableCollection])
    func errorOccurred(error:Error)
}

class CollectionListLayout: NSObject {
    
    fileprivate var _queue:OperationQueue?
    var _slug:String
    
    var queue:OperationQueue{
        get{
            if _queue == nil{
                _queue = OperationQueue.init()
            }
            return _queue!
        }
        set{
            _queue = newValue
        }
    }
    var manager:CollectionBulkManager
    var _delegate:CollectionListLayoutDelegate
    
    init(managerPara:CollectionBulkManager? = nil,slug:String,delegate:CollectionListLayoutDelegate,storyLimit:Int=4) {
        
        if managerPara != nil{
            manager = managerPara!
        }
        else{
            manager = CollectionBulkManager(slug: slug, startImmediately: false, storyLimit: storyLimit)
        }
        _delegate = delegate
        _slug = slug
        super.init()
        configure()
    }
    
    func make(){
        manager.startFetch()
    }
    
    func reset(){
        _queue?.cancelAllOperations()
        manager = CollectionBulkManager.init(slug: _slug, startImmediately: false)
        configure()
    }
    
    
    func configure(){
        
        manager.completion = {[weak self] collectionPara, error in
            guard let weakSelf = self else {
                return
            }
            
            if let someError = error{
                weakSelf._delegate.errorOccurred(error: someError)
                return
            }
            guard let collection = collectionPara else{return}
            
            let strongSelf = weakSelf
            strongSelf.queue.addOperation({
                let renderableCollections = strongSelf.makeRenderables(collectionPara: collection)
                DispatchQueue.main.async(execute: {
                    strongSelf._delegate.didFetchRenderableCollections(renderables: renderableCollections)
                })
            })
            
            
        }
    }
    
    func makeRenderables(collectionPara:CollectionModel) -> [RenderableCollection]{
        let stories = collectionPara.items.filter({$0.type ?? "" == "story"})
        
        let collections = collectionPara.items.filter({$0.type ?? "" == "collection"})
        
        var renderableCollections:[RenderableCollection] = []
        
        for (_, collection) in collections.enumerated(){
            let renderableCollection = RenderableCollection.init(slug: collection.slug, name: collection.name, type: collection.type, items: collection.collection?.items ?? [], originalCollectionPara:collection.collection)
            renderableCollections.append(renderableCollection)
        }
        
        if stories.count > 0{
            let renderableCollectionForStories = RenderableCollection.init(slug: nil, name: "", type: "collection", items: stories, originalCollectionPara:collectionPara)
            renderableCollections.append(renderableCollectionForStories)
        }
        return renderableCollections
    }
}

class RenderableCollection:NSObject{
    var slug:String?
    var name:String?
    var type:String?
    var items:[CollectionItem] = []
    var originalCollection:CollectionModel?
    convenience init(slug:String?, name:String?, type:String?, items:[CollectionItem], originalCollectionPara:CollectionModel?=nil){
        self.init()
        self.slug = slug
        self.name = name
        self.type = type
        self.items = items
        self.originalCollection = originalCollectionPara
    }
}

