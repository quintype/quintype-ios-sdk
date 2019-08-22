//
//  Author.swift
//  Quintype
//
//  Created by Albin CR on 2/24/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation

public class Author:SafeJsonObject{
    
    public var avatar_s3_key:String?
    public var avatar_url:String?
    public var bio:String?
    public var id:NSNumber?
    public var name:String?
    public var publisher_id:NSNumber?
    public var slug:String?
    public var twitter_handle:String?
    public var contributor_role:ContributorRole?
    public var contributor_Image:UIImage?
    
    override public func setValue(_ value: Any?, forKey key: String)
    {
         if key == "contributor_role"
         {
            if let valued = value as? [String:AnyObject]
            {
                let storyMeta = ContributorRole()
                storyMeta.setValuesForKeys(valued)
                self.contributor_role = storyMeta
            }
         }
        else
         {
            super.setValue(value, forKey: key)
         }
    }
    
}

public class ContributorRole:SafeJsonObject
{
    public var id:NSNumber?
    public var name:String?
}

public class Contributors:SafeJsonObject
{
    public var authors:[Author] = []
    public var role_id:NSNumber?
    public var role_name:String?
    public var contributor_Image:UIImage?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "authors"
        {
            guard let unwrappedAuthorsArray = value as? [[String:AnyObject]] else{
                return
            }
            for authorsJson in unwrappedAuthorsArray {
                
                let author = Author()
                Converter.jsonKeyConverter(dictionaryArray: authorsJson, completion: { (data) in
                    author.setValuesForKeys(data )
                    self.authors.append(author)
                })
            }
        }
        else
        {
            super.setValue(value, forKey: key)
        }
    }
}
