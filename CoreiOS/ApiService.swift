//
//  ApiService.swif.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

// This is where API is defined
public class ApiService:ApiServiceProtocol{
    
    //collection, //login //TODO:- On hold -
    
    
    
    // details
    
    
    
    public init(){}
    
    let api = Http.sharedInstance
    public let baseURL = "https://thequint-web.staging.quintype.io"
    
    
    //MARK:- Get stories API call -
    
    public func getStories(options:storiesOption,fields: [String]?,offset: Int?,limit: Int?,storyGroup: String?,completion:@escaping (String?,[Story]?)->() ) {
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "offset":offset,
            "limit":limit,
            "story-group":storyGroup
        ]
        
        if let opt = options.value{
            
            if opt.isEmpty{
                
                param[opt.first!.key] = opt.first!.value
                
            }
        }
        
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.getStories, parameter: param as [String : AnyObject]?) { (status,error, data) in
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                ApiParser.StoriesParser(data: data, completion: { (storiesObject) in
                    
                    DispatchQueue.main.async {
                        
                        completion(nil,storiesObject)
                        
                    }
                })
            }
            
            
        }
        
    }
    
    
    
    
    //MARK:- Get story by id
    public func getStoryFromId(storyId: String,completion:@escaping (String?,Story?)->()) {
        // api/v1/stories/{story-id}
        
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.getStories + "/" + storyId, parameter: nil) { (status,error,data) in
            
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                ApiParser.storyParser(data: data, completion: { (storyObject) in
                    
                    completion(nil, storyObject)
                    
                })
                
            }
            
        }
        
    }
    
    
    
    
    public func getPublisherConfig(completion:@escaping (String?,Config?)->()) {
        
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.configUrl, parameter: nil) { (status,error,data) in
            
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                
                ApiParser.configParser(data: data, completion: { (configObject) in
                    
                    completion(nil, configObject)
                    
                })
                
            }
            
        }
    }
    
    
    public func search(searchBy:searchOption,fields: [String]?,offset:Int?,limit:Int?,completion:@escaping (String?,Search?)->()) {
        
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "offset":offset,
            "limit":limit,
            ]
        
        if let opt = searchBy.value{
            
            if opt.isEmpty{
                
                param[opt.first!.key] = opt.first!.value
                
            }
        }
        
        
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.search, parameter: param as [String : AnyObject]?){ (status,error,data) in
            
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                
                
                ApiParser.searchParser(data: data, completion: { (searchObject) in
                    
                    completion(nil, searchObject)
                    
                })
                
            }
            
        }
        
        
    }
    
    
    
    public func getRelatedStories(storyId: String,SectionId:String?,fields: [String]?,completion:@escaping (String?,[Story]?)->()) {
        
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "section-id":SectionId
            
        ]
        
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.relatedStories(storyId: storyId), parameter: param as [String : AnyObject]?){ (status,error,data) in
            print(data)
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                ApiParser.StoriesParser(data: data,parseKey:"related-stories",completion: { (storiesObject) in
                    
                    DispatchQueue.main.async {
                        
                        completion(nil,storiesObject)
                        
                    }
                })
            }
            
            
        }
        
    }
    
    public func getCommentsForStory(storyId:String,completion:@escaping (String?,[Comment]?)->()) {
        
        
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.getComments(storyId: storyId), parameter: nil){ (status,error,data) in
            
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                ApiParser.commentsParser(data: data,completion: { (commentObject) in
                    
                    DispatchQueue.main.async {
                        
                        completion(nil,commentObject)
                        
                    }
                })
            }
            
            
        }
    }
    
    
    public func getStoryFromSlug(slug: String,completion:@escaping (String?,Story?)->()) {
        
        let urlSlug = slug.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        var param:[String:Any?] = [
            
            "slug":urlSlug,
            ]
        
        print(urlSlug)
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.getStoryFromSlug, parameter: param as [String : AnyObject]?){ (status,error,data) in
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                ApiParser.storyParser(data: data,completion: { (storyObject) in
                    
                    DispatchQueue.main.async {
                        
                        completion(nil,storyObject)
                        
                    }
                })
            }
            
            
            
            
        }
    }
    
    public func getBreakingNews(fields:[String]?,limit:Int?,offset:Int?,completion:@escaping (String?,[Story]?)->()) {
        
        
        let stringURLFields = fields?.joined(separator: ",").replacingOccurrences(of: ",", with: "%2C")
        
        var param:[String:Any?] = [
            
            "fields":stringURLFields,
            "offset":offset,
            "limit":limit,
            ]
        
        api.call(method: "get", urlString: baseURL + Constants.urlConfig.breakingNews, parameter: param as [String : AnyObject]?){ (status,error,data) in
            
            if !status{
                if let errorMessage = error{
                    completion(errorMessage,nil)
                }
            }else{
                ApiParser.StoriesParser(data: data, completion: { (storiesObject) in
                    
                    DispatchQueue.main.async {
                        
                        completion(nil,storiesObject)
                        
                    }
                })
            }
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    public func postComment(comment:String?,storyId:Int){
        
        var param:[String:Any?] = [
            
            "story-content-id":storyId,
            "text":comment,
            
            ]
        
        api.call(method: "post", urlString: Constants.urlConfig.postComment, parameter: param as [String : AnyObject]?){ (status,error,data) in
            
        }
    }
    
    public func getCurrentUser(storyId:Int){

        api.call(method: "get", urlString: Constants.urlConfig.getCurrentUser, parameter: nil){ (status,error,data) in
            
            print(data)
            
            
        }
    }
    
    public func getAuthor(autherId:Int){
        

        
        api.call(method: "get", urlString: Constants.urlConfig.GetAuthor + "/\(autherId)", parameter: nil){ (status,error,data) in
            
            print(data)
            
        }
    }
    
    
    
    func facebookLogin(complete:(UIWebView)->()){
        
        let screenSize: CGRect = UIScreen.main.applicationFrame
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height:
            screenSize.height))
        
        //                if let url = URL(string: "http://apple.com") {
        //                    let request = URLRequest(url: url)
        //                    webView.loadRequest(request)
        //                }
        
        webView.loadRequest(URLRequest(url: URL(string:baseURL + Constants.urlConfig.facebookLogin)!))
        complete(webView)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getImgixMeta(elem: CardStoryElement){
        
    }
    
    
    func getLatestAppVersion(version: Int, publisherName: String){
        
    }
    
}
