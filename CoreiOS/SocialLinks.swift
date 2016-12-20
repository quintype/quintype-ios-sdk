//
//  SocialLinks.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class SocialLinks: SafeJsonObject {
    
    public var facebook_url:String?
    public var twitter_url:String?
    public var instagram_url:String?
    public var google_plus_url:String?
    
    
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.facebook_url = aDecoder.decodeObject(forKey: "facebook_url") as? String
        self.twitter_url = aDecoder.decodeObject(forKey: "twitter_url") as? String
        self.instagram_url = aDecoder.decodeObject(forKey: "instagram_url") as? String
        self.google_plus_url = aDecoder.decodeObject(forKey: "google_plus_url") as? String

    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(facebook_url, forKey: "facebook_url")
        aCoder.encode(twitter_url, forKey: "twitter_url")
        aCoder.encode(instagram_url, forKey: "instagram_url")
        aCoder.encode(google_plus_url, forKey: "google_plus_url")
    }
}
