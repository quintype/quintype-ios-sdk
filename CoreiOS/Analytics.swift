//
//  Analytics.swift
//  CoreiOS
//
//  Created by Albin CR on 12/19/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Analytics:Completion{
    
    //shared instances
    let api = Http.sharedInstance
    let object = Quintype.sharedInstance
    let defaults = UserDefaults.standard
    
    var sessionId:String?
    var deviceId:String?
    var publisherId:Int?
    var memberId: Int?
    var userAgent: String?
    var software: String?
    var deviceModel: String!
    var storyVisitPageViewEventId:String?
    let deviceType:String = "iOS"
    var deviceMaker:String = "Apple"
    let deviceIsMobile:Bool = true
    var parameter:[String:Any] = [:]
    
    public init(){
        
        object.delegate = self
    }
    
    func finished() {
        //print("Finished initlizing")
        sessionId = NSUUID().uuidString
        deviceId = UIDevice.current.identifierForVendor?.description
        publisherId = Constants.publisherConfig.publisherId
        userAgent = defaults.string(forKey: Constants.publisherConfig.appNameKey)! + "iOS"
        software = "iOS - " + UIDevice.current.systemVersion.description
        deviceModel = UIDevice.current.model
        storyVisitPageViewEventId = NSUUID().uuidString
        
        parameter = [
            "session-event-id":sessionId as Any,
            "id":UUID().uuidString,
            "device-tracker-id":deviceId as Any,
            "publisher-id":publisherId as Any,
            "referrer":"",
        ]
        if Constants.user.memberId != 0{
            memberId = Constants.user.memberId
            parameter["member-id"] = memberId
        }//TODO: - Set user in user model
    }
    
    open func trackPageViewSectionVisit(section: String){//1
        
        parameter["page-type"] = pageType.section.rawValue
        parameter["url"] = section
        
        Track(eventName: eventType.viewPage.rawValue, parameter: parameter as [String : AnyObject])
        
    }
    
    //MARK: - - Trackhome page visit -
    
    open func trackPageViewHomeVisit(){//2
        
        parameter["page-type"] = pageType.home.rawValue
        parameter["url"] = Constants.storage.getBaseUrl()
        
        Track(eventName: eventType.viewPage.rawValue, parameter: parameter as [String : AnyObject])
        
    }
    
    //MARK: - Tracksearch results page view -
    
    open func trackPageViewSearchResults(){//3
        parameter["page-type"] = pageType.searchResults.rawValue
        parameter["url"] = ""
        
        Track(eventName: eventType.viewPage.rawValue, parameter: parameter as [String : AnyObject])
    }
    
    //MARK: - Trackstory page visit -
    
    /**
     - parameter story: story instance that is visited
     */
    
    open func trackPageViewStoryVisit(story: Story){//4
        
        
        parameter["page-type"] = pageType.story.rawValue
        parameter["url"] = story.slug
        parameter["page-view-event-id"] = storyVisitPageViewEventId
        parameter["story-content-id"] = story.story_content_id
        
        Track(eventName: eventType.viewStory.rawValue, parameter: parameter as [String : AnyObject])
        
    }
    
    //MARK: - Tracka story visit -
    
    /**
     - parameter story: story that has been visited
     */
    
    open func trackStoryVisit(story: Story){//5
        parameter["page-type"] = pageType.story.rawValue
        parameter["url"] = story.slug
        parameter["page-view-event-id"] = storyVisitPageViewEventId
        parameter["story-content-id"] = story.story_content_id
        
        Track(eventName: eventType.viewStory.rawValue, parameter: parameter as [String : AnyObject])
    }
    
    //MARK: - Trackstory element visit -
    
    /**
     - parameter story:        story to which this story element belongs
     - parameter storyElement: story element that is visited
     */
    
    open func trackStoryElementVisit(story: Story, cardStoryElement: CardStoryElement){//6
        
        let card = cardForStoryElement(story: story, storyElement: cardStoryElement)
        
        parameter["story-content-id"] = story.story_content_id
        parameter["story-version-id"] = story.story_version_id
        parameter["card-content-id"] = card?.content_id
        parameter["card-version-id"] = card?.content_version_id
        parameter["story-element-id"] = cardStoryElement.id
        parameter["story-element-type"] = cardStoryElement.type
        parameter["page-view-event-id"] = storyVisitPageViewEventId
        
        Track(eventName: eventType.storyElementView.rawValue, parameter: parameter as [String : AnyObject])
        
    }
    
    //MARK: - Trackan action on story element -
    
    /**
     - parameter story:        story to which the story element belongs to
     - parameter storyElement: story element on which action is performed
     - parameter actionTimestamp: time in millis at which action happened
     - parameter action:       action on story element
     */
    
    open func trackStoryElementAction(story: Story, cardStoryElement: CardStoryElement, actionTimestamp: Float, action: String){//7
        
        let card = cardForStoryElement(story: story, storyElement: cardStoryElement)
        
        parameter["story-content-id"] = story.story_content_id
        parameter["story-version-id"] = story.story_version_id
        parameter["card-content-id"] = card?.content_id
        parameter["card-version-id"] = card?.content_version_id
        parameter["story-element-id"] = cardStoryElement.id
        parameter["story-element-type"] = cardStoryElement.type
        parameter["page-view-event-id"] = storyVisitPageViewEventId
        parameter["story-element-action"] = actionTimestamp
        parameter["action-timestamp"] = action
        
        Track(eventName: eventType.storyElementView.rawValue, parameter: parameter as [String : AnyObject])
        
    }
    
    //MARK: - Tracka content share event -
    
    /**
     - parameter story:    story which is shared
     - parameter provider: provider to which content is share
     */
    
    open func trackShare(story: Story, provider: String){//10
        parameter["page-view-event-id"] = storyVisitPageViewEventId
        parameter["social-media-type"] = provider
        parameter["story-content-id"] = story.story_content_id
        parameter["content-type"] = story.content_type
        parameter["url"] = story.slug
        parameter["page-type"] = pageType.story.rawValue
        
        Track(eventName: eventType.viewStory.rawValue, parameter: parameter as [String : AnyObject])
    }
    
    //MARK: - Find same card inside story's cards - 🌸
    private func cardForStoryElement(story: Story, storyElement: CardStoryElement) -> Card? {
        for card in story.cards {
            for elem in card.story_elements {
                if(elem.id == storyElement.id) {
                    return card
                }
            }
        }
        return nil
    }
    
    //MARK: - Main tracker function - 😍
    public func Track(eventName:String,parameter:[String:AnyObject]){
        
        if let baseUrl = Constants.publisherConfig.analyticBaseUrl{
            
            let param:[String:Any] = [
                "event":parameter,
                "event-type":"page-view"
            ]
            
            api.call(method: "post", urlString: baseUrl + Constants.analyticConfig.analyticEvent, parameter: param as [String : AnyObject]?) { (status, error, data) in
                
                
            }
            
        }
    }
    
}
