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
      let defaults = UserDefaults.standard
    
    //MARK: - API calling function - Private
    public func call(method:String,urlString: String,parameter:[String:AnyObject]?, completion: @escaping (Bool,String?,[String: AnyObject]?) -> ()) {
        
        var urlString = urlString
        var url = NSMutableURLRequest(url: URL(string: urlString)!)
        //        print(url,parameter)
        
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
                
                do {
                    url.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                    //print(url.httpBody as Any)
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                url.addValue("application/json", forHTTPHeaderField: "Content-Type")
                if (defaults.value(forKey: Constants.login.auth) != nil){
                    url.addValue(defaults.value(forKey: Constants.login.auth) as! String, forHTTPHeaderField: Constants.login.auth)
                }
                //
                
            }
        }
        
        
        URLSession.shared.dataTask(with: url as URLRequest) { (data, response, error) in
            
            print("error0",data?.description as Any,response as Any,error as Any)
            
            #if DEBUG
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                    
                    print(json as Any)
                }
            #endif
            
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async {
                    ////print("api call failled")
                    completion(false,"Unknown error occured",nil)
                }
                return
            }else{
                
                do {
                    
                    if let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                        
                        let httpResponse = response as? HTTPURLResponse
                        let status = httpResponse?.statusCode
                        if status == 200 || status == 201{
                            
                            if let httpResponse = response as? HTTPURLResponse {
                                if let loginHeader = httpResponse.allHeaderFields["x-qt-auth"] as? String {
                                    self.defaults.set(loginHeader, forKey: Constants.login.auth)

                                }
                            }
                            
                            DispatchQueue.main.async {
//                                print("Api call successfull",json)
                                completion(true,nil,json as [String : AnyObject]?)
                            }
                        }else{
                            
                            if let errorMessage = json?["error"]{
                                if let message =  errorMessage["message"] as? String{
                                    DispatchQueue.main.async {
                                        ////print("Unable to get data")
                                        completion(false,message,nil)
                                    }
                                }
                            }
                        }
                    }
                    else{
                        let message = "Unable to get data"
                        #if DEBUG
                            if let analyticsCount = data?.count{
                                print("analytic recived ..",analyticsCount)
                            }
                        #endif
                        DispatchQueue.main.async {
                            completion(false,message,nil)
                        }
                    }
                    
                }
//                catch let error {
//                    print("entered json parsing error",error)
//                    //print(error)
//                    DispatchQueue.main.async {
//                        ////print("Api call successfull but cannot parse")
//                        completion(false,"Cannot parse the data",nil)
//                    }
//                    
//                }
            }
            
            }.resume()
        
        
    }
    
}
