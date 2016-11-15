//
//  http.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

class Http{
    
    static let sharedInstance = Http()
    
    //MARK: - API calling function - Private
    public func call(method:String,urlString: String,parameter:[String:AnyObject]?, completion: @escaping (Bool,[String: AnyObject]?) -> ()) {
        
        let url = NSMutableURLRequest(url: URL(string: urlString)!)
        
        url.httpMethod = method.capitalized
        
        if let parameter = parameter{
            url.addValue("application/json", forHTTPHeaderField: "Content-Type")
            url.httpBody = try! JSONSerialization.data(withJSONObject: parameter, options:[])
            
        }
        print(urlString)
        URLSession.shared.dataTask(with: url as URLRequest) { (data, response, error) in
            
            
            
            if error != nil {
                print(error as Any)
                completion(false,nil)
                return
            }
            
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String: AnyObject] {
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        print(jsonDictionaries)
                        
                        completion(true,jsonDictionaries)
                    }
                    
                }
                
            } catch let jsonError {
                print(jsonError)
                completion(false,nil)
                
            }
            }.resume()
        
    }
    
}
