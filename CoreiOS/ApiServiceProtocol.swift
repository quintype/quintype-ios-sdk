//
//  ApiService.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//


import Foundation
//Quintype api service protocol
public protocol ApiServiceProtocol {
    
    /**
     get stories from api service
     
     - parameter offset:      offset value
     - parameter limit:       limit value
     - parameter sectionName: name of the section
     - parameter fields:      fields needed in json
     - parameter tagName:     name of the tag
     - parameter storyGroup:  story group
     

     */
    func getStories(offset: String, limit: String, sectionName: String, fields: String, tagName: String, storyGroup: String)
    

    
    /**
     Get stories from given ids of story order
     
     - parameter storyOrder: comma separated ids of stories
     - parameter fields:     fields interested
     

     */
    func getStoriesFromId(storyOrder: String, fields: String)
    
    /**
     Get stories for a particular story group
     
     - parameter storyGroup: relevant story group
     

     */
    func getStoriesInStoryGroup(storyGroup: String)
    
    
    func getStoriesInStoryGroupInSectionStacks(storyGroup: String, section: String)
    
    /**
     Get publisher config from api service
     

     */
    func getPublisherConfig()
    
    /**
     Get search results for given search term
     
     - parameter term: the search term
     - parameter from: the offset to fetch results from
     

     */
    func getSearchResults(term: String, from: Int)
    
    /**
     Get stories of a particular template
     
     - parameter template: name of the template
     - parameter limit: number of stories to fetch
     

     */
    func getStoriesByTemplate(template: String, limit: Int)
    
    /**
     Get paginated stories for the home page
     
     - parameter limit: number of stories to fetch
     - parameter offset: number of stories to fetch from
     

     */
    func getTopStories(limit: Int, offset: Int)
    
    /**
     Get paginated stories for a tag page
     
     - parameter limit: number of stories to fetch
     - parameter offset: number of stories to fetch from
     - parameter tag: tag to fetch stories from
     

     */
    func getStoriesByTag(limit: Int, offset: Int, tag: String)
    
    /**
     Get paginated stories for a section page
     
     - parameter limit: number of stories to fetch
     - parameter offset: number of stories to fetch from
     - parameter section: section to fetch stories from

     
     */
    func getStoriesBySection(limit: Int, offset: Int, section: String)
    
    /**
     Get a story given an id
     
     - parameter id: id of the story
     
     */
    func getStoryFromId(id: String)
    
    /**
     Get related stories for a specified story
     
     - parameter id:     story content id
     - parameter fields: story fields required in response

     */
    func getRelatedStories(id: String, fields: String)
    
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
    
    func getTweetCount(story: Story)
    /**
     Get google plus share count of a story
     
     - parameter story: story
     
     - returns: a wrapper with number of plus ones
     */
    func getGooglePlusCount(story: Story)
    
    /**
     Get stories by slug
     
     :param: stories by particular slug
     */
    
    func getStoryFromSlug(slug: String)
    /**
     Get app version
     
     :param:      */
    
    func getLatestAppVersion(version: Int, publisherName: String)
}

extension ApiServiceProtocol{
    
    // Provide default implementations to make these optional
    
    func getStories(offset: String, limit: String, sectionName: String, fields: String, tagName: String, storyGroup: String){}
    
    func getStoriesFromId(storyOrder: String, fields: String){}
    
    func getStoriesInStoryGroup(storyGroup: String){}
    
    func getStoriesInStoryGroupInSectionStacks(storyGroup: String, section: String){}
    
    func getPublisherConfig(){}
    
    func getSearchResults(term: String, from: Int){}
    
    func getStoriesByTemplate(template: String, limit: Int){}
    
    func getTopStories(limit: Int, offset: Int){}
    
    func getStoriesByTag(limit: Int, offset: Int, tag: String){}
    
    func getStoriesBySection(limit: Int, offset: Int, section: String){}
    
    func getStoryFromId(id: String){}
    
    func getRelatedStories(id: String, fields: String){}
    
    func getUserEngagments(id: String){}
    
    func getImgixMeta(elem: CardStoryElement){}
    
    func getTweetCount(story: Story){}
    
    func getGooglePlusCount(story: Story){}
    
    func getStoryFromSlug(slug: String){}
    
    func getLatestAppVersion(version: Int, publisherName: String){}

   
    
}
