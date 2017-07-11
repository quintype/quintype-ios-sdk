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

public enum returnType:String{
    
    case json = "json"
    case object = "object"
}

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
    
    var entityManager:EntityManager = EntityManager.init(mapperPara: [:])
    
    //MARK: - Default initilizer
    public init(){}
    
    open func setEntityManager(entityManagerPara:EntityManager){
        entityManager = entityManagerPara
    }
    
    //MARK:- Get publisher details -
    public func getPublisherConfig(cache:cacheOption,Success:@escaping (Config?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.configUrl
        
        api.call(method: "get", urlString: url, parameter: nil,cache:cache, Success: { (data) in
            
            ApiParser.configParser(data: data , completion: { (configObject) in
                Quintype.publisherConfig = configObject
                
                DispatchQueue.main.async { Success(configObject) }
                
            })
            
        }) { (error) in
            
            Error(error)
            
        }
    }
    
    public typealias json = ([String:AnyObject]?) ->()
    public var json: json?
    
    //MARK: - Get stories -
    public func getStories(options:storiesOption,fields: [String]?,offset: Int?,limit: Int?,storyGroup: String?,cache:cacheOption,returnDataType:returnType = returnType.object ,Success:@escaping ([Story]?)->(),json:json? = nil,Error:@escaping (String?)->()) {
        
        let stringURLFields = fields?.joined(separator: ",")
        
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
        
        let url = baseUrl + Constants.urlConfig.getStories
        
        api.call(method: "get", urlString: url, parameter: param as [String : AnyObject]?,cache:cache, Success: { (data) in
            
            
            
            ApiParser.StoriesParser(data: data , completion: { (storiesObject) in
                
                DispatchQueue.main.async { Success(storiesObject) }
                
            })
            
            if returnDataType == returnType.json{
                
                if let jsonData = data{ DispatchQueue.main.async { json!(jsonData) } }
            }
            
        }) { (error) in
            
            Error(error)
            
        }
    }
    
    //    //MARK:- Get story by id
    public func getStoryFromId(storyId: String,cache:cacheOption,Success:@escaping (Story?)->(),Error:@escaping (String?)->()) {
        
        
        let url = baseUrl + Constants.urlConfig.getStories + "/" + storyId
        
        api.call(method: "get", urlString: url, parameter: nil,cache:cache, Success: { (data) in
            
            ApiParser.storyParser(data: data as! [String : AnyObject]?, completion: { (storiesObject) in
                
                DispatchQueue.main.async { Success(storiesObject) }
                
            })
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
    }
    
    //    //MARK:- Get realted story
    public func getRelatedStories(storyId: String,SectionId:String?,fields: [String]?,cache:cacheOption,Success:@escaping ([Story]?)->(),Error:@escaping (String?)->()) {
        
        
        let stringURLFields = fields?.joined(separator: ",")
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "section-id":SectionId
            
        ]
        
        
        
        let url = baseUrl + Constants.urlConfig.relatedStories(storyId: storyId)
        
        api.call(method: "get", urlString: url, parameter: param as [String : AnyObject]?,cache:cache, Success: { (data) in
            
            ApiParser.StoriesParser(data: data ,parseKey:"related-stories",completion: { (storiesObject) in
                
                DispatchQueue.main.async { Success(storiesObject) }
                
            })
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
        
    }
    
    //MARK:- Search
    public func search(searchBy:searchOption,fields: [String]?,offset:Int?,limit:Int?,cache:cacheOption,Success:@escaping (Search?)->(),Error:@escaping (String?)->()) {
        
        let stringURLFields = fields?.joined(separator: ",")
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
        
        let url = baseUrl + Constants.urlConfig.search
        
        
        
        api.call(method: "get", urlString: url, parameter: param as [String : AnyObject]?,cache:cache, Success: { (data) in
            
            ApiParser.searchParser(data: data as! [String : AnyObject]?, completion: { (searchObject) in
                
                DispatchQueue.main.async { Success(searchObject) }
                
            })
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
    }
    
    //MARK:- Get comments of a particular story
    public func getCommentsForStory(storyId:String,cache:cacheOption,Success:@escaping ([Comment]?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.getComments(storyId: storyId)
        
        
        api.call(method: "get", urlString: url, parameter:nil,cache:cache, Success: { (data) in
            
            ApiParser.commentsParser(data: data as! [String : AnyObject]?,completion: { (commentObject) in
                
                DispatchQueue.main.async { Success(commentObject) }
                
            })
            
        }) { (error) in
            
            Error(error)
            
        }
        
    }
    
    //MARK:- Get story form slug
    public func getStoryFromSlug(slug: String,cache:cacheOption,Success:@escaping (Story?)->(),Error:@escaping (String?)->()) {
        
        //        let urlSlug = slug.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = baseUrl + Constants.urlConfig.getStoryFromSlug + "?slug=" + slug
        
        api.call(method: "get", urlString: url, parameter:nil,cache:cache, Success: { (data) in
            
            ApiParser.storyParser(data: data as! [String : AnyObject]?,completion: { (storyObject) in
                
              //  DispatchQueue.main.async { Success(storyObject) }
                
                self.entityManager.getStoryEntitiesSerialized(story: storyObject, completion: { (storyd) in
                    DispatchQueue.main.async { Success(storyObject) }
                })
                
            })
            
        }) { (error) in
            
            Error(error)
            
        }
        
    }
    
    //MARK:- Get breaking news
    public func getBreakingNews(fields:[String]?,limit:Int?,offset:Int?,cache:cacheOption,Success:@escaping ([Story]?)->(),Error:@escaping (String?)->()) {
        
        let stringURLFields = fields?.joined(separator: ",")
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "offset":offset,
            "limit":limit,
            ]
        
        let url = baseUrl + Constants.urlConfig.breakingNews
        
        api.call(method: "get", urlString: url, parameter:param as [String : AnyObject]?,cache:cache, Success: { (data) in
            
            ApiParser.StoriesParser(data: data as! [String : AnyObject]?, completion: { (storiesObject) in
                
                DispatchQueue.main.async { Success(storiesObject) }
                
            })
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
    }
    
    
    //    //MARK: Facebook Token Sender
    
    public func facebookTokenLogin(facebookToken:String,Success:@escaping (Bool)->(),Error:@escaping (String?)->()) {
        
        let param: [String: Any] = [
            "token": [
                "access-token": facebookToken
            ]
        ]
        
        let url = baseUrl + Constants.urlConfig.facebookLogin
        
        api.call(method: "post", urlString: url, parameter:param as [String : AnyObject]?,cache:cacheOption.none, Success: { (data) in
            
            DispatchQueue.main.async { Success(true) }
            
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
        
        
    }
    
    //MARK: - Facebook logout -
    public func logoutFacebook(){
        
        defaults.remove(Constants.login.auth)
        
    }
    
    //MARK: - POST Commants -
    //TODO: - Need testing, check error types for post -
    
    public func postComment(comment:String?,storyId:Int,Success:@escaping (Any?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.postComment
        
        let param:[String:Any?] = [
            
            "story-content-id":storyId,
            "text":comment,
            
            ]
        
        api.call(method: "post", urlString: url, parameter:param as [String : AnyObject]?,cache:cacheOption.none, Success: { (data) in
            
            DispatchQueue.main.async { Success(true) }
            
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
    }
    //MARK: - Get Current User -
    public func getCurrentUser(storyId:Int,Success:@escaping (Any?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.getCurrentUser
        
        api.call(method: "get", urlString: url, parameter:nil,cache:cacheOption.none, Success: { (data) in
            
            DispatchQueue.main.async { Success(true) }
            
            
        }) { (error) in
            
            Error(error)
            
        }
    }
    
    //MARK: - Get Auther -
    public func getAuthor(autherId:String,Success:@escaping (Author?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.getAuthor
        
        api.call(method: "get", urlString: url + "/\(autherId)", parameter: nil,cache:cacheOption.none, Success: { (data) in
            
            if let authorDetails = data{
                
                ApiParser.authorDetailParser(data: authorDetails, completion: { (authorObject) in
                    
                    DispatchQueue.main.async { Success(authorObject) }
                    
                })
                
            }
            
        }) { (error) in
            
            Error(error)
            
        }
        
        
    }
    
    //MARK: - Bulk Api Call -
    public func bulkCall(param:[String:[String:[String:Any]]],cache:cacheOption,Success:@escaping (Any?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.bulkCall
        
        api.call(method: "post", urlString: url, parameter: param as [String : AnyObject]?,cache:cache, Success: { (data) in
            
            DispatchQueue.main.async { Success(data) }
            
        }) { (err) in
            
            Error(err)
            
        }
    }
    
    //MARK: - Collection Api Call -
    public func collectionApiRequest(stack:String,cache:cacheOption,param:[String:AnyObject]? = nil,Success:@escaping (Any?)->(),Error:@escaping (String?)->()) {
        
        let url = baseUrl + Constants.urlConfig.collectionRequest(stack: stack)
        
        api.call(method: "get", urlString: url, parameter: param,cache:cache, Success: { (data) in
            
//          ApiParser.collectionParser(data: data, completion: { (collectionObject) in
//            
//              DispatchQueue.main.async { Success(collectionObject) }
//            
//          })
            Success(data)
            
        }) { (err) in
            
            print(err)
            Error(err)
            
        }
        
    }
    
    
    
}
