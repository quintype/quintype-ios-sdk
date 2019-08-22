//
//  File.swift
//  CoreiOS
//
//  Created by Albin CR on 11/11/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class CardStoryElementSubTypeMetaData:SafeJsonObject {
    
    //Twitter meta
    public var tweet_url: String?
    public var tweet_id: String?
    //Instagram meta
    //    public var instagram_url:String?
    //    public var instagram_id:String?
    //Quote meta
    public var attribution: String?
    public var content: String?
    //Video Meta
    public var video_id:String?
    public var thumbnail_url:String?
    public var player_id:String?
    public var video_url:String?
    public var player_url:String?
    public var embed_code:String?
    //Q&A
    public var question:String?
    public var answer:String?
    public var type:String?
    public var linkedStory:LinkedStory?
    public var interviewer:QuestionAndAnswerAttribute?
    public var interviewee:QuestionAndAnswerAttribute?
    //Reference
    public var name:String?
    public var url:String?
    //BrightCove
    public var poster_url: String?
    public var account_id: String?
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "linked_story"{
            let linkedStoryd = LinkedStory()
            
            if let valued = value as? [String:AnyObject]{
                linkedStoryd.setValuesForKeys(valued)
                if valued.count > 0{
                    self.linkedStory = linkedStoryd
                    self.linkedStory?.story_content_id = valued["story-content-id"] as! String!
                }
            }
          
        }
        else if key == "interviewer"
        {
            let attributer = QuestionAndAnswerAttribute()
            
            if let valued = value as? [String:AnyObject]{
                attributer.setValuesForKeys(valued)
                if valued.count > 0{
                    interviewer = attributer
                }
            }
        }
        else if key == "interviewee"
        {
            let attributer = QuestionAndAnswerAttribute()
            
            if let valued = value as? [String:AnyObject]{
                attributer.setValuesForKeys(valued)
                if valued.count > 0{
                    interviewee = attributer
                }
            }
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
    
}

public class QuestionAndAnswerAttribute:SafeJsonObject
{
    public var updated_at:NSNumber?
    public var slug:String?
    public var name:String?
    public var type:String?
    
    public override func setValue(_ value: Any?, forKey key: String) {
        if key == "updated-at"
        {
            if let valueD =  value as? NSNumber
            {
                self.updated_at = valueD
            }
        }
        else
        {
            super.setValue(value, forKey: key)
        }
    }
}
