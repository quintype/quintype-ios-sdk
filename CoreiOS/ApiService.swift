//
//  ApiService.swif.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

//TODO:- On hold -
//collection, //login, // details

//TODO - Enable reuse function to remove cachetype detection and cache retrival


import Foundation

// This is where API is defined
public class ApiService{
    
    //MARK: - Calling Http shared inatance
    let api = Http.sharedInstance
    let defaults = UserDefaults.standard
    
    //MARK: - Accesing base url from Constants file
    private var baseUrl:String {
        get {
            return Constants.urlConfig.getBaseUrl()
        }
    }
    
    //MARK: - Default initilizer
    public init(){}
    
    
    
    
    //    var saveToDisk:Bool = false
    var cacheTime:Int?
    //    var cacheStatus:Bool = true
    var replaceWithNewData = false
    
    
    
    //MARK: - Api calling wrapper for reuseing the call (Common Call for all get Calls)
    func apiCall(apiCallName:String,method:String,url:String,parameter:[String:AnyObject]?,cacheType:String,cacheTime:Int,Success:@escaping (Any?)->(),Error:@escaping (String?)->()) {
        
        api.call(method: method, urlString: url, parameter: parameter, Success: { (data) in
            
            if cacheType == Constants.cache.none{
                Success(data)
            }else{
                Cache.cacheData(data: data as Any, key: apiCallName, cacheTimeInMinute: cacheTime, cacheType: cacheType)
                Success(data)
            }
            
            
        }) { (error) in
            
            if let errorMessage = error{
                Error(errorMessage)
            }
            
        }
    }
    
    
    
    
    
    //MARK:- Get publisher details -
    public func getPublisherConfig(cache:cacheOption,Success:@escaping (Config?)->(),Error:@escaping (String?)->()) {
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0]
        
        var cacheType:String?
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.loadOldCacheAndReplaceWithNew
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
        }
        
        let url = baseUrl + Constants.urlConfig.configUrl
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: nil, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.configParser(data: data as! [String : AnyObject]?, completion: { (configObject) in
                    Quintype.publisherConfig = configObject
                    if retuenData{
                        DispatchQueue.main.async {
                            
                            Success(configObject)
                            
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.configParser(data: data as! [String : AnyObject]?, completion: { (configObject) in
                    Quintype.publisherConfig = configObject
                    DispatchQueue.main.async {
                        Success(configObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
    }
    
    //MARK: - Get stories -
    public func getStories(options:storiesOption,fields: [String]?,offset: Int?,limit: Int?,storyGroup: String?,cache:cacheOption,Success:@escaping ([Story]?)->(),Error:@escaping (String?)->()) {
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "offset":offset,
            "limit":limit,
            "story-group":storyGroup
        ]
        
        if let opt = options.value{
            
            if !opt.isEmpty{
                
                for (index,options) in opt{
                    param[index] = options
                }
                
            }
        }
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0] + param.description.replacingOccurrences(of: "-", with: "_")
        ////print(apiCallName)
        
        var cacheType:String?
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
            
            
        }
        
        let url = baseUrl + Constants.urlConfig.getStories
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: param as [String : AnyObject]?, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.StoriesParser(data: data as! [String : AnyObject]?, completion: { (storiesObject) in
                    if retuenData{
                        DispatchQueue.main.async {
                            Success(storiesObject)
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.StoriesParser(data: data as! [String : AnyObject]?, completion: { (storiesObject) in
                    
                    DispatchQueue.main.async {
                        Success(storiesObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
    }
    
    
    //MARK:- Get story by id
    public func getStoryFromId(storyId: String,cache:cacheOption,Success:@escaping (Story?)->(),Error:@escaping (String?)->()) {
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0] + storyId
        ////print(apiCallName)
        
        var cacheType:String?
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
            
            
        }
        
        let url = baseUrl + Constants.urlConfig.getStories + "/" + storyId
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: nil, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.storyParser(data: data as! [String : AnyObject]?, completion: { (storiesObject) in
                    if retuenData{
                        DispatchQueue.main.async {
                            Success(storiesObject)
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.storyParser(data: data as! [String : AnyObject]?, completion: { (storyObject) in
                    
                    DispatchQueue.main.async {
                        Success(storyObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
        
        
    }
    
    //MARK:- Get realted story
    public func getRelatedStories(storyId: String,SectionId:String?,fields: [String]?,cache:cacheOption,Success:@escaping ([Story]?)->(),Error:@escaping (String?)->()) {
        
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "section-id":SectionId
            
        ]
        
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0] + storyId + param.description.replacingOccurrences(of: "-", with: "_")
        ////print(apiCallName)
        
        var cacheType:String?
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
            
            
        }
        
        let url = baseUrl + Constants.urlConfig.relatedStories(storyId: storyId)
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: param as [String : AnyObject]?, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.StoriesParser(data: data as! [String : AnyObject]?,parseKey:"related-stories",completion: { (storiesObject) in
                    if retuenData{
                        DispatchQueue.main.async {
                            Success(storiesObject)
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.StoriesParser(data: data as! [String : AnyObject]?,parseKey:"related-stories",completion: { (storiesObject) in
                    
                    DispatchQueue.main.async {
                        Success(storiesObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
        
    }
    
    //MARK:- Search
    public func search(searchBy:searchOption,fields: [String]?,offset:Int?,limit:Int?,cache:cacheOption,Success:@escaping (Search?)->(),Error:@escaping (String?)->()) {
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        var searchKey:String = ""
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "offset":offset,
            "limit":limit,
            ]
        
        if let opt = searchBy.value{
            
            if !opt.isEmpty{
                
                param[opt.first!.key] = opt.first!.value
                searchKey = opt.first!.value
                
            }
        }
        
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0] + searchKey + param.description.replacingOccurrences(of: "-", with: "_")
        ////print(apiCallName)
        
        var cacheType:String?
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
            
            
        }
        
        let url = baseUrl + Constants.urlConfig.search
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: param as [String : AnyObject]?, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.searchParser(data: data as! [String : AnyObject]?, completion: { (searchObject) in
                    if retuenData{
                        DispatchQueue.main.async {
                            Success(searchObject)
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.searchParser(data: data as! [String : AnyObject]?, completion: { (searchObject) in
                    
                    
                    DispatchQueue.main.async {
                        Success(searchObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
        
    }
    
    //MARK:- Get comments of a particular story
    public func getCommentsForStory(storyId:String,cache:cacheOption,Success:@escaping ([Comment]?)->(),Error:@escaping (String?)->()) {
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0] + storyId
        var cacheType:String?
        
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
            
            
        }
        
        let url = baseUrl + Constants.urlConfig.getComments(storyId: storyId)
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: nil, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.commentsParser(data: data as! [String : AnyObject]?,completion: { (commentObject) in
                    if retuenData{
                        DispatchQueue.main.async {
                            Success(commentObject)
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.commentsParser(data: data as! [String : AnyObject]?,completion: { (commentObject) in
                    
                    DispatchQueue.main.async {
                        Success(commentObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
    }
    
    //MARK:- Get story form slug
    public func getStoryFromSlug(slug: String,cache:cacheOption,Success:@escaping (Story?)->(),Error:@escaping (String?)->()) {
        
        let urlSlug = slug.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0] + "?slug=" + slug
        var cacheType:String?
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
            
            
        }
        
        let url = baseUrl + Constants.urlConfig.getStoryFromSlug + "?slug=" + slug
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: nil, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.storyParser(data: data as! [String : AnyObject]?,completion: { (storyObject) in
                    if retuenData{
                        DispatchQueue.main.async {
                            Success(storyObject)
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.storyParser(data: data as! [String : AnyObject]?,completion: { (storyObject) in
                    
                    
                    DispatchQueue.main.async {
                        Success(storyObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
    }
    
    //MARK:- Get breaking news
    public func getBreakingNews(fields:[String]?,limit:Int?,offset:Int?,cache:cacheOption,Success:@escaping ([Story]?)->(),Error:@escaping (String?)->()) {
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "offset":offset,
            "limit":limit,
            ]
        
        let apiCallName = "\(#function)".components(separatedBy: "(")[0] + param.description.replacingOccurrences(of: "-", with: "_")
        var cacheType:String?
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                replaceWithNewData = true
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
            
            
        }
        
        let url = baseUrl + Constants.urlConfig.breakingNews
        
        func requestCall(retuenData:Bool = true){
            
            self.apiCall(apiCallName:apiCallName,method:"get",url: url, parameter: param as [String : AnyObject]?, cacheType:cacheType!, cacheTime: cacheTime!,Success: { (data) in
                
                ApiParser.StoriesParser(data: data as! [String : AnyObject]?, completion: { (storiesObject) in
                    if retuenData{
                        DispatchQueue.main.async {
                            Success(storiesObject)
                        }
                    }
                })
                
            }) { (error) in
                
                Error(error)
                
            }
            
        }
        
        Cache.retriveCacheData(keyName: apiCallName, completion: { (data) in
            
            if data != nil {
                ApiParser.StoriesParser(data: data as! [String : AnyObject]?, completion: { (storiesObject) in
                    
                    
                    DispatchQueue.main.async {
                        Success(storiesObject)
                    }
                    
                    if self.replaceWithNewData{
                        requestCall(retuenData: false)
                    }
                })
                
            }else{
                requestCall()
            }
        })
    }
    
    //MARK: Facebook Token Sender
    
    public func facebookTokenLogin(facebookToken:String,Success:@escaping (Bool)->(),Error:@escaping (String?)->()) {
        
        let parameter: [String: Any] = [
            "token": [
                "access-token": facebookToken
            ]
        ]
        //        print(parameter)
        let url = baseUrl + Constants.urlConfig.facebookLogin
        
        api.call(method: "post", urlString: url, parameter: parameter as [String : AnyObject]?, Success: { (status) in
            Success(true)
        }, Error: { (error) in
            Error(error)
        })
        
        
    }
    //MARK: - Facebook logout -
    public func logoutFacebook(){
        
        defaults.remove(Constants.login.auth)
        
    }
    
    
    //MARK: -POST Commants
    //TODO: -Need testing, check error types for post
    
    public func postComment(comment:String?,storyId:Int,Success:@escaping (Any?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.postComment
        
        let param:[String:Any?] = [
            
            "story-content-id":storyId,
            "text":comment,
            
            ]
        api.call(method: "post", urlString: url, parameter: param as [String : AnyObject]?, Success: { (data) in
            
            Success(data)
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
    }
    
    public func getCurrentUser(storyId:Int,Success:@escaping (Any?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.getCurrentUser
        
        api.call(method: "get", urlString: url,parameter: nil, Success: { (data) in
            
            Success(data)
            
        }) { (error) in
            
            Error(error)
            
        }
    }
    
    public func getAuthor(autherId:String,Success:@escaping (Author?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.GetAuthor
        
        api.call(method: "get", urlString: url + "/\(autherId)", parameter: nil, Success: { (data) in
            
//

            if let authorDetails = data{
                
                ApiParser.authorDetailParser(data: authorDetails, completion: { (authorObject) in
                
                    print(authorObject)
                    Success(authorObject)
                    
                })
                
                
            }
        
            
            
            
        }) { (error) in
            
            Error(error)
            
        }
        
    }
    
    
    
}
