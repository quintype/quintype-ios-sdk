//
//  http.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation
import SystemConfiguration

class Http{
    
    static let sharedInstance = Http()
    let defaults = UserDefaults.standard
    
    private func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    public func call(method:String,urlString: String,parameter:[String:AnyObject]?, Success: @escaping ([String: AnyObject]?) -> (),Error:@escaping (String?) -> ()) {
        
        if isInternetAvailable(){
            var urlString = urlString.replacingOccurrences(of: " ", with: "%20")
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
                            url = NSMutableURLRequest(url: URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))!)
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
                
//                print("error0",data?.description as Any,response as Any,error as Any)
                
                #if DEBUG
                    if let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                        
                        print(json as Any)
                    }
                #endif
                
                if error != nil {
//                    print(error as Any)
                    DispatchQueue.main.async {

                        Error("Unknown error occured,\(error.debugDescription)")

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
                                    Success(json as [String : AnyObject]?)
                                    
                                }
                            }else{
                                
                                if let errorMessage = json?["error"]{
                                    if let message =  errorMessage["message"] as? String{
                                        DispatchQueue.main.async {
                                            ////print("Unable to get data")
                                            Error(message)
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            
                            #if DEBUG
                                if let analyticsCount = data?.count{
                                    print("analytic recived ..",analyticsCount)
                                }
                            #endif
                            DispatchQueue.main.async {
                                Error(Constants.HttpError.pageNotFound)
                            }
                        }
                        
                    }
                    //                catch let error {
                    //                    print("entered json parsing error",error)
                    //                    //print(error)
                    //                    DispatchQueue.main.async {
                    //                        ////print("Api call successfull but cannot parse")
                    //                        Error("Api call successfull but cannot parse")
                    //                    }
                    //
                    //                }
                }
                
                }.resume()
        }else{
            
            Error(Constants.HttpError.noInternetConnection)
        }
    }

}
