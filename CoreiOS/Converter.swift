//
//  Converter.swift
//  CoreiOS
//
//  Created by Albin CR on 12/6/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Converter{
    
//    public class func jsonKeyConverterForArrayOfDictionary(dictionaryArray:[[String:AnyObject]],completion:@escaping ([String:AnyObject]) -> ()){
//        
//        
//        
//        for var dictionary in dictionaryArray as! [[String:AnyObject]]{
//            
//            for (_,dictionaryDetails) in dictionary.enumerated(){
//                
//                let key = dictionaryDetails.key
//                let value = dictionaryDetails.value
//                let letters = CharacterSet.alphanumerics
//                
//                if (key.trimmingCharacters(in: letters) != "") {
//                    
//                    let newKey = key.replacingOccurrences(of: "-", with: "_")
//                    
//                    finalDictionaryArray.removeValue(forKey: key)
//                    finalDictionaryArray[newKey] = value
//                    
//                }
//                
//            }
//        }
//        completion(finalDictionaryArray)
//        
//    }
    


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

//    var sections:[NSObject] = []
//    if key == jsonkey {
//    var singleSection = model
//    // if 2 array comes
//    for var section in value as! [[String:AnyObject]]{
//
//    for (_,sectionDetail) in section.enumerated(){
//
//    let key = sectionDetail.key
//    let value = sectionDetail.value
//
//
//    let letters = CharacterSet.alphanumerics
//    if (key.trimmingCharacters(in: letters) != "") {
//
//    let newKey = key.replacingOccurrences(of: "-", with: "_")
//    section.removeValue(forKey: key)
//    print(newKey)
//    section[newKey] = value
//    print(section[newKey]!)
//
//    }
//
//    }
//
//    singleSection.setValuesForKeys(section as! [String: AnyObject])
//    sections.append(singleSection)
//    }
//    completion(sections)
//    // else 1 array
//
//    } else {
//    super.setValue(value, forKey: key)
//    }
//
//
//
//
//}
