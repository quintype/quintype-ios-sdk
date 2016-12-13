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
    public func call(method:String,urlString: String,parameter:[String:AnyObject]?, completion: @escaping (Bool,String?,[String: AnyObject]?) -> ()) {
        
        var urlString = urlString
        var url = NSMutableURLRequest(url: URL(string: urlString)!)
        print(url)
        
        url.httpMethod = method.capitalized
        
        if let parameter = parameter{
            
            if method.capitalized == "Get"{
                var counter = 0
                
                parameter.forEach({ (param) in
                    
                    if param.value as? String != nil{
                        
                        if counter == 0{
                            
                            urlString = urlString + "?" + param.key + "=" + (param.value as! String)
                            counter = counter + 1
                            
                        }else{
                            
                            urlString = urlString + "&" + param.key + "=" +  (param.value as! String)
                            
                        }
                        url = NSMutableURLRequest(url: URL(string: urlString)!)
                    }
                    
                })
                
            }else{
                url.addValue("application/json", forHTTPHeaderField: "Content-Type")
                url.httpBody = try! JSONSerialization.data(withJSONObject: parameter, options:[])
            }
        }
        
        
        URLSession.shared.dataTask(with: url as URLRequest) { (data, response, error) in
            
            print("error0",data?.description,response,error)
            let response = response
            
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async {
                    print("api call failled")
                    completion(false,"Unknown error occured",nil)
                }
                return
            }else{
                
                do {
                    
                    if let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                        
                        let httpResponse = response as? HTTPURLResponse
                        let status = httpResponse?.statusCode
                        if status == 200 || status == 201{
                            DispatchQueue.main.async {
                                print("Api call successfull")
                                completion(true,nil,json as [String : AnyObject]?)
                            }
                        }else{
                            
                            if let errorMessage = json?["error"]{
                                if let message =  errorMessage["message"] as? String{
                                    DispatchQueue.main.async {
                                        print("Unable to get data")
                                        completion(false,message,nil)
                                    }
                                }
                            }
                        }
                        
                    }else{
                        let message = "Unable to get data"
                        print("Unable to get data")
                        completion(false,message,nil)
                    }
                    
                } catch let jsonError {
                    print("entered json parsing error")
                    print(jsonError)
                    DispatchQueue.main.async {
                        print("Api call successfull but cannot parse")
                        completion(false,"Cannot parse the data",nil)
                    }
                    
                }
            }
            
            }.resume()
        
        
    }
    
}
