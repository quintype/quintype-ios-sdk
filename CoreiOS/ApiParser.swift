//
//  ApiParser.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

class ApiParser{
    
    //MARK:- Stroy Parser -
    class func storyParser(data:[String:AnyObject]?,completion:@escaping (Story) -> () ){
        if var storyDictionary = data?["story"] as? [String:AnyObject]{
            
            
            let story = Story()
            
            for (_,storyDetail) in storyDictionary.enumerated(){
                
                let key = storyDetail.key
                let value = storyDetail.value
                let letters = CharacterSet.alphanumerics
                if (key.trimmingCharacters(in: letters) != "") {
                    print(key)
                    let newKey = key.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: "?", with: "_")
                    storyDictionary.removeValue(forKey: key)
                    storyDictionary[newKey] = value
                    print(storyDictionary[newKey]!)
                    
                }
                
            }
            story.setValuesForKeys(storyDictionary)
            completion(story)
            
        }
        
        
    }
    
    //MARK:- Get stories parser-
    class func StoriesParser(data:[String:AnyObject]?,parseKey:String = "stories",completion:@escaping ([Story]) -> () ){
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
                        print(newKey)
                        storyDictionary[newKey] = value
                        print(storyDictionary[newKey]!)
                        
                        
                    }
                    
                }
                story.setValuesForKeys(storyDictionary)
                stories.append(story)
                
            }
            completion(stories)
        }
        
        
    }
    
    
    
    //MARK:- Config parser -
    class func configParser(data:[String:AnyObject]?,completion:@escaping (Config) -> () ){
        
        print(data)
        
        let config = Config()
        if var configDetails = data{
            for (_,singleConfigDetails) in configDetails.enumerated(){
                
                let key = singleConfigDetails.key
                let value = singleConfigDetails.value
                let letters = CharacterSet.alphanumerics
                if (key.trimmingCharacters(in: letters) != "") {
                    print(key)
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
    class func searchParser(data:[String:AnyObject]?,completion:@escaping (Search) -> () ){
        
        if var searchDictionary = data?["results"] as? [String:AnyObject]{
            
            let search = Search()
            
            for (_,searchDetail) in searchDictionary.enumerated(){
                
                let key = searchDetail.key
                let value = searchDetail.value
                let letters = CharacterSet.alphanumerics
                if (key.trimmingCharacters(in: letters) != "") {
                    print(key)
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
    class func commentsParser(data:[String:AnyObject]?,completion:@escaping ([Comment]) -> () ){
        
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
                        print(newKey)
                        commentDictionary[newKey] = value
                        
                    }
                    
                }
                comment.setValuesForKeys(commentDictionary)
                comments.append(comment)
                
            }
            completion(comments)
        }
    }
    
}




