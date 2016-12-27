//
//  Converter.swift
//  CoreiOS
//
//  Created by Albin CR on 12/6/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Converter{

    // MARK: - Convert incomming json in readable format by replacing "- or ?" by "_" -
    public class func jsonKeyConverter(dictionaryArray:[String:AnyObject]?,completion:@escaping ([String:AnyObject]) -> ()){
        
        if var finalDictionaryArray = dictionaryArray{
            
            for (_,dictionary) in finalDictionaryArray.enumerated(){
                
                let key = dictionary.key
                let value = dictionary.value
                let letters = CharacterSet.alphanumerics
                
                if (key.trimmingCharacters(in: letters) != "") {
                    
                    let newKey = key.replacingOccurrences(of: "-", with: "_")
                    
                    finalDictionaryArray.removeValue(forKey: key)
                    finalDictionaryArray[newKey] = value
                    
                }
            }
            completion(finalDictionaryArray)
        }
    }
    
}
