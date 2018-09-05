////
////  Reachablity.swift
////  CoreiOS
////
////  Created by Albin CR on 12/22/16.
////  Copyright © 2016 Albin CR. All rights reserved.
////
//
//import Foundation
//
//
//import Foundation
//import SystemConfiguration
//
//public enum IJReachabilityType {
//    case WWAN,
//    WiFi,
//    NotConnected
//}
//
//
//struct NetworkStatusConstants  {
//    static let kNetworkAvailabilityStatusChangeNotification = "kNetworkAvailabilityStatusChangeNotification"
//    static let Status = "Status"
//    static let Offline = "Offline"
//    static let Online = "Online"
//    static let Unknown = "Unknown"
//}
//
//
//public class IJReachability {
//    
//    public class func isConnectedToNetwork() -> Bool {
//        
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//        }) else {
//            return false
//        }
//        
//        var flags : SCNetworkReachabilityFlags = []
//        
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
//            return false
//        }
//        
//        let isReachable = flags.contains(.reachable)
//        let needsConnection = flags.contains(.connectionRequired)
//        
//        return isReachable && !needsConnection
//    }
//    
//    public class func isConnectedToNetworkOfType() -> IJReachabilityType {
//        
//        
//        //MARK: - TODO Check this when I have an actual iOS 9 device.
//        if !self.isConnectedToNetwork() {
//            return .NotConnected
//        }
//        
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//        }) else {
//            return .NotConnected
//        }
//        
//        var flags : SCNetworkReachabilityFlags = []
//        
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
//            return .NotConnected
//        }
//        
//        let isReachable = flags.contains(.reachable)
//        let isWWAN = flags.contains(.isWWAN)
//        
//        if isReachable && isWWAN {
//            return .WWAN
//        }
//        
//        if isReachable && !isWWAN {
//            return .WiFi
//        }
//        
//        return .NotConnected
//    }
//
////    class func monitorNetworkChanges() {
////        
////        let host = "google.com"
////        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
////        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
////        
////        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
////            
////            let status:String?
////            
////            if !flags.contains(SCNetworkReachabilityFlags.connectionRequired) && flags.contains(SCNetworkReachabilityFlags.reachable) {
////                status = NetworkStatusConstants.Online
////            } else {
////                status =  NetworkStatusConstants.Offline
////            }
////            
////            NotificationCenter.default.postNotificationName(NetworkStatusConstants.kNetworkAvailabilityStatusChangeNotification,
////                                                                      object: nil,
////                                                                      userInfo: [NetworkStatusConstants.Status: status!])
////            
////        }, &context)
////        
////        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes)
////    }
//}
