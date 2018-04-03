//
//  ApiParser.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

open class ApiParser{
    
    
    open class func sanitize(keyd:String) -> String{
        var key = keyd
        let letters = CharacterSet.alphanumerics
        if (key.trimmingCharacters(in: letters) != ""){
            key = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
        }
        return key
    }
    
    //MARK:- Stroy Parser -
    open class func storyParser(data:[String:AnyObject]?,completion:@escaping (Story) -> () ){
        if var storyDictionary = data?["story"] as? [String:AnyObject]{
            
            let story = Story()
            
            for (_,storyDetail) in storyDictionary.enumerated(){
                
                let key = storyDetail.key
                let value = storyDetail.value
                let letters = CharacterSet.alphanumerics
                if (key.trimmingCharacters(in: letters) != "") {
                    ////print(key)
                    let newKey = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
                    storyDictionary.removeValue(forKey: key)
                    storyDictionary[newKey] = value
                    ////print(storyDictionary[newKey]!)
                    
                }
                
            }
            story.setValuesForKeys(storyDictionary)
            completion(story)
            
        }
        
        
    }
    
    //MARK:- Get stories parser-
    open class func StoriesParser(data:[String:AnyObject]?,parseKey:String = "stories",completion:@escaping ([Story]) -> () ){
        var stories = [Story]()
        if let storyArray = data?[parseKey] as? [[String: AnyObject]] {
            
            for var storyDictionary in storyArray {
                let story = Story()
                
                for (_,postDetail) in storyDictionary.enumerated(){
                    
                    let key = postDetail.key
                    let value = postDetail.value
                    
                    
                    let letters = CharacterSet.alphanumerics
                    if (key.trimmingCharacters(in: letters) != "") {
                        
                        let newKey = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
                        storyDictionary.removeValue(forKey: key)
                        ////print(newKey)
                        storyDictionary[newKey] = value
                        ////print(storyDictionary[newKey]!)
                        
                        
                    }
                    
                }
                story.setValuesForKeys(storyDictionary)
                stories.append(story)
                
            }
            completion(stories)
        }
        
        
    }
    
    
    
    //MARK:- Config parser -
    open class func configParser(data:[String:AnyObject]?,completion:@escaping (Config) -> () ){
        let config = Config()
        if var configDetails = data{
            for (_,singleConfigDetails) in configDetails.enumerated(){
                
                let key = singleConfigDetails.key
                let value = singleConfigDetails.value
                let letters = CharacterSet.alphanumerics
                if (key.trimmingCharacters(in: letters) != "") {
                    ////print(key)
                    let newKey = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
                    configDetails.removeValue(forKey: key)
                    configDetails[newKey] = value
                    
                }
                
            }
            config.setValuesForKeys(configDetails)
            completion(config)
        }
    }
    
    
    //MARK:- Search parser -
    open class func searchParser(data:[String:AnyObject]?,completion:@escaping (Search) -> () ){
        
        if var searchDictionary = data?["results"] as? [String:AnyObject]{
            
            let search = Search()
            
            for (_,searchDetail) in searchDictionary.enumerated(){
                
                let key = searchDetail.key
                let value = searchDetail.value
                let letters = CharacterSet.alphanumerics
                if (key.trimmingCharacters(in: letters) != "") {
                    ////print(key)
                    let newKey = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
                    searchDictionary.removeValue(forKey: key)
                    searchDictionary[newKey] = value
                    
                }
                
            }
            search.setValuesForKeys(searchDictionary)
            completion(search)
            
        }
    }
    
    
    
    //MARK:- Comments parser -
    open class func commentsParser(data:[String:AnyObject]?,completion:@escaping ([Comment]) -> () ){
        
        var comments = [Comment]()
        if let commentArray = data?["comments"] as? [[String: AnyObject]] {
            
            for var commentDictionary in commentArray {
                let comment = Comment()
                
                for (_,commentDetail) in commentDictionary.enumerated(){
                    
                    let key = commentDetail.key
                    let value = commentDetail.value
                    
                    
                    let letters = CharacterSet.alphanumerics
                    if (key.trimmingCharacters(in: letters) != "") {
                        
                        let newKey = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
                        commentDictionary.removeValue(forKey: key)
                        ////print(newKey)
                        commentDictionary[newKey] = value
                        
                    }
                    
                }
                comment.setValuesForKeys(commentDictionary)
                comments.append(comment)
                
            }
            completion(comments)
        }
    }
    
    open class func authorDetailParser(data:[String:AnyObject]?,completion:@escaping (Author) -> () ){
        
        if var autherArray = data?["author"] as? [String: AnyObject] {
            
            let autherDetails = Author()
            
            for (_,autherDetail) in autherArray.enumerated(){
                
                let key = autherDetail.key
                let value = autherDetail.value
                let letters = CharacterSet.alphanumerics
                if (key.trimmingCharacters(in: letters) != "") {
                    ////print(key)
                    let newKey = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
                    autherArray.removeValue(forKey: key)
                    autherArray[newKey] = value
                    
                }
                
            }
            autherDetails.setValuesForKeys(autherArray)
            completion(autherDetails)
            
        }
        
    }

    
    open class func collectionParser(data:[String:AnyObject]?, completion:@escaping(_ collection:CollectionModel, _ error:Error?) -> Void){
        
        if let someData = data{
            let collection = CollectionModel.init()
            var collectionDict:[String:AnyObject] = [:]
            for (_, enumeratedObject) in someData.enumerated(){
                
                let value = enumeratedObject.value
                let key = ApiParser.sanitize(keyd: enumeratedObject.key)
                collectionDict.removeValue(forKey: key)
                collectionDict[key] = value
            }
            collection.setValuesForKeys(collectionDict)
            completion(collection, nil)
        }
    }
    
    
    open class func collectionBulkParser(data:Any?, completion:@escaping(_ collection:[String:CollectionModel], _ error:Error?) -> Void){
        
        guard let someData = data as? [String:AnyObject] else {
            return
        }
        
        guard let results = someData["results"] as? [String:AnyObject] else{
            return
        }
        var collectionMapping:Dictionary<String,CollectionModel> = [:]
        for (index, value) in Array(results.values).enumerated(){
            
            
            ApiParser.collectionParser(data: value as? [String:AnyObject], completion: { (collection, error) in
             
                
                let keyArray = Array(results.keys)
                collectionMapping[keyArray[index]] = collection
            })
        }
        completion(collectionMapping, nil)
        
        
    }
    
    open class func engagmentParser(data:Any?,completion:@escaping(_ engagment:Engagement?,_ error:Error?)->()){
        
        guard let dataD = data as? [String:Any] else { return completion(nil, nil)}
        let engagment = Engagement()
        engagment.setValuesForKeys(dataD)
        completion(engagment, nil)
        
    }
    
    open class func engagmentBulkParser(data:Any?,completion:@escaping(_ engagmentDict:[String:Engagement]?,_ error:Error?)->()){
        
        guard let dataD = data as? [String:Any],let resultDict = dataD["results"] as? [String:Any] else { return completion(nil, nil)}
        
        var engagmentDict:[String:Engagement] = [:]
        
        for (key,value) in resultDict {
            if let valueD = value as? [String:Any]{
                let engagment = Engagement()
                engagment.setValuesForKeys(valueD)
                engagmentDict[key] = engagment
            }
        }
        
        completion(engagmentDict, nil)
        
    }

}



