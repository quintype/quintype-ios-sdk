//
//  File.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class CardStoryElement {
    
    //Common data
    public var id: String?
    public var title: String?
    public var description: String?
    public var text: String?
    public var type: String?
    //Sub types
    public var subType: String?
    public var subTypeMeta: CardStoryElementSubTypeMetaData?
    //Image related data
    public var imageS3Key: String?
    public var imageMeta: ImageMetaData?
    //Url related data
    public var embedUrl: String?
    public var url: String?
    public var pageUrl: String?
    //JS related data
    public var embedJs: String?
    public var decodedJsEmbed: String?
    //Video related data
    public var videoId:String?
    //Twitter related data
    public var tweetId: Int?
    public var isTypeJsEmbedWithTwitter: Bool?
    //Polltype related data
    public var polltypeId: Int?
    
    //collection of story element
    public var storyElements: [CardStoryElement] = []
    
}
