//
//  StoryMetadata.swift
//  Pods
//
//  Created by Arjun P A on 05/07/17.
//
//

import Foundation

public class StoryMetadata:SafeJsonObject{
    public var story_attributes:[String:AnyObject]?
    public var review_rating : ReviewRating?
    public var is_closed : Bool = false
    public var viewType:ViewConterViewType = .Unknown
    public var storyTheme:StoryTheme = .Unknown
    public var sponsored_by:String?
    public var reference_url:String?
    public var linkedStory:LinkedStory?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "story-attributes"{
            if let valued = value as? [String:AnyObject]{
                
                if let viewTypeString = valued["view-counterview-type"] as? String{
                    self.viewType = ViewConterViewType(value: viewTypeString)
                }
                
                if let theme = valued["theme"] as? [String],theme.count > 0{
                    self.storyTheme = StoryTheme(value: theme[0])
                }
                
                if let linkedCounterViewStoryJson = valued["linked-view-counterview-story"] as? [String:Any]{
                    let counterViewStory = LinkedStory()
                    counterViewStory.setValuesForKeys(linkedCounterViewStoryJson)
                    self.linkedStory = counterViewStory
                }
                
                story_attributes = valued
            }
            
        }else if  key == "review-rating"{
            let rating = ReviewRating()
            if let unwrappedValue = value as? [String:AnyObject]{
                rating.setValuesForKeys(unwrappedValue)
            }
            self.review_rating = rating
        }else if key == "is-closed"{
            if let unwrappedValue = value as? Bool{
                self.is_closed = unwrappedValue
            }
        }else if  key == "sponsored-by"{
            if let newValue = value as? String{
                self.sponsored_by = newValue
            }
        }
        else if key == "reference-url"{
            if let newValue = value as? String{
                self.reference_url = newValue
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
}

public class ReviewRating:SafeJsonObject{
    public var label:String?
    public var value:Double = 0.0
    
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "value"{
            if let valueString = value as? String , let valueDouble = Double(valueString){
                self.value  = valueDouble
            }
        }
        else{
            super.setValue(value, forKey: key)
        }
    }
}

public enum StoryTheme:String{
    case Longform = "longform"
    case Parallax = "parallax"
    
    case Unknown
    
    init(value:String){
        self = StoryTheme(rawValue: value) ?? .Unknown
        
    }
}
public enum ViewConterViewType:String{
    case View = "view"
    case CounterView = "counter-view"
    case Unknown
    
    init(value:String){
        self = ViewConterViewType(rawValue: value) ?? .Unknown
        
    }
    
}
