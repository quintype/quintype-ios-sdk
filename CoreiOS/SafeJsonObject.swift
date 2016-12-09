//
//  SafeJsonObject.swift
//  CoreiOS
//
//  Created by Albin CR on 12/5/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class SafeJsonObject: NSObject {
   
    override public func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            print(key ,":", value)
            super.setValue(value, forKey: key)
        }
    }
    
}



//do {
//    
//    let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
//    
//    let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: AnyObject]
//    
//    if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
//        
//        self.posts = [Post]()
//        
//        for var postDictionary in postsArray {
//            let post = Post()
//            print(postDictionary)
//            for (_,postDetail) in postDictionary.enumerated(){
//                
//                let key = postDetail.key
//                let value = postDetail.value
//                
//                print(postDictionary)
//                
//                let letters = CharacterSet.alphanumerics
//                if (key.trimmingCharacters(in: letters) != "") {
//                    print(key)
//                    let newKey = key.replacingOccurrences(of: "-", with: "_")
//                    postDictionary.removeValue(forKey: key)
//                    postDictionary[newKey] = value
//                    print(postDictionary[newKey]!)
//                    
//                    
//                }
//                
//            }
//            post.setValuesForKeys(postDictionary)
//            self.posts.append(post)
//        }
//        
//    }
//    
//} catch let err {
//    print(err)
//}
