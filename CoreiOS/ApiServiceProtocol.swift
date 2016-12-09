//
//  ApiService.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//


import Foundation
//Quintype api service protocol
protocol ApiServiceProtocol {
    
    /**
     get stories from api service
     
     - parameter offset:      offset value
     - parameter limit:       limit value
     - parameter sectionName: name of the section
     - parameter fields:      fields needed in json
     - parameter tagName:     name of the tag
     - parameter storyGroup:  story group
     
     
     */
    func getStories(options:storiesOption,fields:[String]?,offset: Int?,limit: Int?,storyGroup: String?,completion:@escaping(String?,[Story]?)->())
    
    
    
    /**
     Get stories from given ids of story order
     
     - parameter storyOrder: comma separated ids of stories
     - parameter fields:     fields interested
     
     
     */
    func getStoryFromId(storyId: String,completion:@escaping (String?,Story?)->())
    
    /**
     Get publisher config from api service
     
     
     */
    func getPublisherConfig(completion:@escaping (String?,Config?)->())
    
    
    /**
     Get search results for given search term
     
     - parameter term: the search term
     - parameter from: the offset to fetch results from
     
     
     */
      func search(searchBy:searchOption,fields: [String]?,offset:Int?,limit:Int?,completion:@escaping (String?,Search?)->())
    
    
    
    /**
     Get related stories for a specified story
     
     - parameter id:     story content id
     - parameter fields: story fields required in response
     
     */
    func getRelatedStories(storyId: String,SectionId:String?,fields: [String]?,completion:@escaping (String?,[Story]?)->())
    
    /**
     Get user engagements of a story
     
     - parameter id: story content id
     
     
     */
    func getUserEngagments(id: String)
    
    // TODO- Comment api -- Need clarification -
    /** -------------------------------------------------------------
     Post a comment to a card or a story.
     
     - parameter text: comment text
     - parameter storyContentId: story content id
     - parameter cardContentId: card content id
     
     func postComment(text: String, user: User, storyContentId: String, cardContentId: String?)
     -----------------------------------------------------------------*/
    
    
    /**
     Get imgix meta data of given story element
     
     - parameter elem: story element
     
     - returns: imgix meta instance
     */
    
    func getImgixMeta(elem: CardStoryElement)
    
    /**
     Get tweet count of a story
     
     - parameter story: story
     
     - returns: A wrapper with the number of tweets
     */
    
    
    func getStoryFromSlug(slug: String)
    /**
     Get app version
     
     :param:      */
    
    func getLatestAppVersion(version: Int, publisherName: String)
}

extension ApiServiceProtocol{
    
    // Provide default implementations to make these optional
    
    func getStories(options:storiesOption,fields:[String]?,offset: Int?,limit: Int?,storyGroup: String?){}
    
    func getStoryFromId(storyId: String){}
    
    func getPublisherConfig(){}
    
    func search(searchBy:searchOption,fields: [String]?,offset:Int?,limit:Int?){}
    
    func getRelatedStories(storyId: String,SectionId:String?,fields: [String]?){}
    
    
    
    
    func getUserEngagments(id: String){}
    
    func getImgixMeta(elem: CardStoryElement){}
    
    func getStoryFromSlug(slug: String){}
    
    func getLatestAppVersion(version: Int, publisherName: String){}
    
    
    
}
