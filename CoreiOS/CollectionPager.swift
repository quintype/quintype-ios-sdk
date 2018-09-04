//
//  CollectionPager.swift
//  CoreApp-iOS
//
//  Created by Arjun P A on 05/05/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import UIKit

public class CollectionPager: NSObject {
    
    var page:Page?
    static var bulkNecessaryFields:Array<String> = ["id","headline","slug","url","hero-image-s3-key","hero-image-metadata","first-published-at","last-published-at","alternative","published-at","author-name","author-id","sections","story-template","summary","metadata"]
    var _slug:String
    typealias COMPLETION_HANDLER = (CollectionModel, Error?) -> ()
    var completion:COMPLETION_HANDLER?
    init(slug:String, offset:Int = 0, pagePara:Page?=nil){
        if let pageParaNotNil = pagePara{
            page = pageParaNotNil
        }
        else{
            page = Page.init(offsetPara: offset, limitPara: 5)
        }
        _slug = slug
        super.init()
    }
    
    func reset(offset:Int = 0){
        page = Page.init(offsetPara: offset, limitPara: 5)
    }
    
    func pageNext(){
        
        if  page != nil && page!.status == Page.PAGING_STATUS.PAGING || page!.status == Page.PAGING_STATUS.LAST_PAGE{
            return
        }
        
        if page != nil && page!.status == Page.PAGING_STATUS.ERRORED{
            page!.minus()
        }
        
        page?.kick()
        var params:[String:AnyObject]?
        if let paged = page{
             params = ["limit":NSNumber.init(value: paged.limit), "offset":NSNumber.init(value: paged.offset)]
        }
        params?["story-fields"] = CollectionPager.bulkNecessaryFields.joined(separator: ",") as NSString
         self.updatePageStatus(status: Page.PAGING_STATUS.PAGING)
        Quintype.api.collectionApiRequest(stack: _slug, cache: cacheOption.none,param:params, Success: { (collectionPara) in
            
            if let collectiond = collectionPara as? [String:AnyObject]{
                ApiParser.collectionParser(data: collectiond, completion: { (collection, error) in
                    
                    if error != nil{

                        self.updatePageStatus(status: Page.PAGING_STATUS.ERRORED)
                    }
                    else{
              
                        self.updatePageStatus(status: Page.PAGING_STATUS.NOT_PAGING)
                        //TODO: -check with backend guys if the offset bug is fixed yet. Then change to limit vs offset comparison
                        if collection.items.count == 0{
                            
                            self.updatePageStatus(status: Page.PAGING_STATUS.LAST_PAGE)
                        }
                        DispatchQueue.main.async(execute: {
                            self.completion?(collection, nil)
                        })
                        
                    }
                    
                    
                })
            }
        }) { (error) in
            //  self.page.status = Page.PAGING_STATUS.ERRORED
            self.updatePageStatus(status: Page.PAGING_STATUS.ERRORED)
        }
        
    }
    func updatePageStatus(status:Page.PAGING_STATUS){
        guard let pageNotNilLet = self.page else{return}
        var pageNotNil = pageNotNilLet
        pageNotNil.status = status
        self.page?.status = status
    }
    
}

public struct Page{
    public enum PAGING_STATUS:Int{
        case NOT_PAGING
        case PAGING
        case LAST_PAGE
        case ERRORED
    }
   public var offset:Int = 0
   public var limit:Int = 0
   public var status:PAGING_STATUS = PAGING_STATUS.NOT_PAGING
   public init(offsetPara:Int = 0, limitPara:Int = 0) {
        
        self.limit = limitPara
        if offsetPara == 0{
            self.offset =  -limitPara
        }
        else{
            self.offset = -limitPara
            self.offset += offsetPara
        }
    }
   public mutating func kick(){
        
        self.offset += self.limit
    }
    
  public  mutating func minus(){
        self.offset -= self.limit
    }
}
