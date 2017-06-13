
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
    
    var cacheKey:String?
    
    static let sharedInstance = Http()
    let defaults = UserDefaults.standard
    
    public class func isInternetAvailable() -> Bool {
        
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
    
    private func createUrlFromParameter(method:String,urlString: String,param:[String:AnyObject]?) -> NSMutableURLRequest {
        
        var urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        var url = NSMutableURLRequest(url: URL(string: urlString)!)
        var counter = 0
        
        url.httpMethod = method.capitalized
        
        if let parameter = param{
            
            if method.capitalized == "Get"{
                
                parameter.forEach({ (param) in
                    
                    if param.value as? String != nil || param.value as? Int != nil {
                        
                        if counter == 0{
                            
                            urlString = urlString + "?" + param.key + "=" + (String(describing: param.value).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
                            counter = counter + 1
                            
                        }else{
                            
                            urlString = urlString + "&" + param.key + "=" +  (String(describing: param.value).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
                            
                        }
                        url = NSMutableURLRequest(url: URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))!)
                    }
                    
                })
                
                cacheKey = url.url!.description
                
                return url
                
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
                
                cacheKey = url.url!.description + parameter.description
                
                return url
                
            }
        }else{
            cacheKey = url.url!.description
            return url
        }
        
    }
    
    
    public func getData(url:NSMutableURLRequest,Success: @escaping ([String: AnyObject]?) -> (), Error:@escaping (String?) -> ()) {
        
        URLSession.shared.dataTask(with: url as URLRequest) { (data, response, error) in
            
            #if DEBUG
                if let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {  }
            #endif
            
            if error != nil {
                
                #if DEBUG
                    print(error as Any)
                #endif
                
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
                                
                                #if DEBUG
                                    print("Api call successfull")
                                #endif
                                
                                Success(json as [String : AnyObject]?)
                                
                            }
                        }else{
                            
                            if let errorMessage = json?["error"]{
                                if let message =  errorMessage["message"] as? String{
                                    DispatchQueue.main.async {
                                        
                                        #if DEBUG
                                            print("Unable to get data")
                                        #endif
                                        
                                        Error(message)
                                    }
                                }
                            }
                        }
                    }
                    else{
                        
                        #if DEBUG
                            if let analyticsCount = data?.count{ print("analytic recived ..",analyticsCount) }
                        #endif
                        
                        DispatchQueue.main.async {
                            Error(Constants.HttpError.pageNotFound)
                        }
                    }
                    
                }
                //                #if DEBUG
                //                    catch let error {
                //                        print("entered json parsing error",error)
                //                        //print(error)
                //                        DispatchQueue.main.async {
                //                            ////print("Api call successfull but cannot parse")
                //                            Error("Api call successfull but cannot parse")
                //                        }
                //
                //                    }
                //                #endif
            }
            
            }.resume()
    }
    
    
    public func call(method:String,urlString: String,parameter:[String:AnyObject]?,cache:cacheOption,Success: @escaping ([String: AnyObject]?) -> (),Error:@escaping (String?) -> ()) {
        
        var cacheType:String?
        var cacheTime:Int?
        
        if let opt = cache.value{
            
            if opt.keys.first == Constants.cache.cacheToMemoryWithTime{
                cacheType = Constants.cache.cacheToMemoryWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToMemoryAndDiskWithTime{
                cacheType = Constants.cache.cacheToMemoryAndDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.loadOldCacheAndReplaceWithNew{
                cacheType = Constants.cache.loadOldCacheAndReplaceWithNew
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.cacheToDiskWithTime{
                cacheType = Constants.cache.cacheToDiskWithTime
                cacheTime = opt.values.first
            }else if opt.keys.first == Constants.cache.oflineCacheToDisk{
                cacheType = Constants.cache.oflineCacheToDisk
                cacheTime = opt.values.first
            }
            
        }else{
            cacheType = Constants.cache.none
            cacheTime = 0
        }
        
        var url = createUrlFromParameter(method: method, urlString: urlString, param: parameter)
        
        if Http.isInternetAvailable(){
            
            url.httpMethod = method.capitalized
            
            let expiryTime = cacheTime! * 60 * 1000
            
            if cacheType == Constants.cache.none{
                
                self.getData(url: url, Success: { (data) in
                    
                    Success(data)
                    
                }, Error: { (error) in
                    
                    Error(error)
                    
                })
                
            }else if cacheType == Constants.cache.loadOldCacheAndReplaceWithNew{
                
                Cache.retriveCacheData(keyName: self.cacheKey!,cachTimelimt:Double(expiryTime), Success: { (data) in
                    
                    let info = data as? [String:Any]
                    
                    Success(info?.first?.value as! [String : AnyObject]?)
                    
                    self.getData(url: url, Success: { (data) in
                        
                        return
                        
                    }, Error: { (error) in
                        
                        return
                        
                    })
                    
                }, error: {
                    
                    self.getData(url: url, Success: { (data) in
                        
                        Cache.cacheData(data: data!, key: self.cacheKey!, cacheTimeInMinute: cacheTime ?? 0, cacheType: cacheType!)
                        
                        Success(data)
                        
                    }, Error: { (error) in
                        
                        Error(error)
                        
                    })
                })
                
                
            }else if cacheType == Constants.cache.oflineCacheToDisk{
                
                self.getData(url: url, Success: { (data) in
                    
                    Cache.cacheData(data: data!, key: self.cacheKey!, cacheTimeInMinute: cacheTime ?? 0, cacheType: cacheType!, oflineStatus: true)
                    
                    Success(data)
                    
                }, Error: { (error) in
                    
                    Error(error)
                    
                })
                
            }else{
                
                Cache.retriveCacheData(keyName: self.cacheKey!,cachTimelimt:Double(expiryTime), Success: { (data) in
                    
                    let info = data as? [String:Any]
                    
                    Success(info?.first?.value as! [String : AnyObject]?)
                    
                }, error: {
                    
                    self.getData(url: url, Success: { (data) in
                        
                        Cache.cacheData(data: data!, key: self.cacheKey!, cacheTimeInMinute: cacheTime ?? 0, cacheType: cacheType!)
                        
                        Success(data)
                        
                    }, Error: { (error) in
                        
                        Error(error)
                        
                    })
                })
            }
            
        }else{
            
            Cache.retriveCacheData(keyName:  (url.url?.absoluteString)!, cachTimelimt: 0, oflineStatus: true, Success: { (data) in
                
                let json = (data as? [String : AnyObject])?.first?.value as? [String:AnyObject]
                
                Success(json)
                
            }, error: {
                Error(Constants.HttpError.noInternetConnection)
                
            })
            
        }
        
    }
    
}
