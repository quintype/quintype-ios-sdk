//
//  CollectionItem.swift
//  Quintype
//
//  Created by Pavan Gopal on 10/25/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation


open class CollectionItem:SafeJsonObject, NSCopying{
    
    open var id:NSNumber?
    open var name:String?
    open var slug:String?
    open var template:String?
    open var type:String?
    open var collection:CollectionModel?
    open var story:Story?
    open var limit: Int = 5
    public var associatedMetadata: AssociatedMetadata?
    
    public var metaData: ColectionMetaData?
    
    
    override open func setValue(_ value: Any?, forKey key: String) {
        
        if key == "story"{
            let datad = ["story":value]
            ApiParser.storyParser(data: datad as [String : AnyObject]?, completion: { (story) in
                self.story = story
            })
        } else if key == "associated_metadata" {
            let associatedMetadata = AssociatedMetadata()
            
            if let valuesD = value as? [String:Any] {
                associatedMetadata.setValuesForKeys(valuesD)
            }
            
            self.associatedMetadata = associatedMetadata
            self.limit = associatedMetadata.getLimitFromMetaData()
            
        } else if key == "metadata" {
            metaData = ColectionMetaData()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.metaData?.setValuesForKeys(data)
            })
        } else{
            super.setValue(value, forKey: key)
        }
    }
    required override public init(){
        super.init()
    }
    required public init(item:CollectionItem) {
        
        id = item.id
        name = item.name
        slug = item.slug
        template = item.template
        type = item.type
        collection = item.collection
        story = item.story
        associatedMetadata = item.associatedMetadata
    }
    
    open func copy(with zone: NSZone? = nil) -> Any{
        let item:CollectionItem = CollectionItem.init()
        item.id = self.id
        item.name = self.name
        item.slug = self.slug
        item.template = self.template
        item.type = self.type
        item.collection = self.collection?.copy() as? CollectionModel
        item.story = self.story?.copy() as? Story
//        item.associatedMetadata = associatedMetadata
        return item
        
    }
}


public class AssociatedMetadata:SafeJsonObject {
    
    public var label: String?
    public var layout: String? {
        didSet {
            let colLayout = CollectionLayout(rawValue: self.layout ?? "") ?? .UNKNOWN
            self.get_inner_collection = colLayout.shouldFetchInnerCollection
        }
    }
    public var coverstory: String?
    public var pagenumber:Int?
    public var show_arrows:Bool = false
    public var slider_type_dots : Bool = true
    
    public var show_author_name : Bool = true
    public var number_of_slider_stories_to_show : Int = 0
    public var number_of_collections_to_show : Int = 0
    public var number_of_slides_to_scroll : Int = 0
    public var show_section_tag : Bool = false
    public var show_time_of_publish : Bool = false
    public var set_scroll_speed : Int = 0
    
    public var show_collection_name : Bool = true
    public var slider_type_dashes : Bool = false
    public var enable_auto_play : Bool = false
    public var full_width_container : Bool = false
    public var number_of_stories_to_show : Int = 0
    public var show_share_count: Bool = false
    public var show_comment_count: Bool = false
    public var number_of_child_stories_to_show: Int = 0
    public var get_inner_collection: Bool = false
    public var read_more_text: String?
    public var number_of_stories_inside_collection_to_show: Int = 0
    
    /*
     
     TODO: Add these properties when required
     
     12: "saving"
     13: "amount"
     14: "headline"
     15: "saving-label"
     16: "amount-label"
     17: "subscription-text"
     
     enable_auto_play: 1
     get_inner_collection: 1
     layout: 1
     number_of_child_stories_to_show: 1
     number_of_collections_to_show: 1
     number_of_slider_stories_to_show: 1
     number_of_stories_inside_collection_to_show: 1
     number_of_stories_to_show: 1
     read_more_text: 1
     show_collection_name: 1
     show_comment_count: 1
     show_share_count: 1
     theme: 1
     
     */
    
    
    
    public var theme:Theme = Theme.Unknown

    
    public enum Theme:String{
        case Dark = "dark"
        case Unknown
        
        init(value:Any?){
            
            if let valueD = value as? String{
                self = Theme(rawValue: valueD) ?? .Unknown
            }else{
                self = .Unknown
            }
            
        }
    }
    
    override open func setValue(_ value: Any?, forKey key: String) {
        if key == "label" {
            if let valueD = value as? [String] {
                self.label = valueD.first
            }
        }
       else  if key == "coverstory"
        {
          if let valueD = value as? [String]{
              self.coverstory = valueD.first
            }
        }
        else if key == "pagenumber"
        {
            if let valueD = value as? [Int]{
                self.pagenumber = valueD.first
            }
        }
        else if key == "number_of_stories_inside_collection_to_show" {
            self.number_of_stories_inside_collection_to_show = convertToInt(value)
        }
        else if key == "number_of_child_stories_to_show" {
            self.number_of_child_stories_to_show = convertToInt(value)
        }
        else if key == "number_of_slider_stories_to_show" {
            self.number_of_slider_stories_to_show = convertToInt(value)
        }
        else if key == "number_of_collections_to_show" {
            self.number_of_collections_to_show = convertToInt(value)
        } else if key == "number_of_stories_to_show" {
            self.number_of_stories_to_show = convertToInt(value)
        }
        else if key == "scroll_speed_ms" {
            if let valueD = value as? Int {
                set_scroll_speed = valueD
            }
        }else if key == "theme"{
            theme = Theme(value: value)
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    private func convertToInt(_ val: Any?) -> Int {
        if let newVal = val as? Int {
            return newVal
        } else if let newVal = val as? String {
            return Int(newVal) ?? 0
        }
        
        return 0
    }
    
    public func getLimitFromMetaData() -> Int {
        
        let currentLayout = CollectionLayout(rawValue: layout ?? "")
        
        var limit = 5
        
        switch currentLayout {
        
        case .none:
            return limit
        case .some(.mainRowWithBundle12s5c1ad):
            limit = (number_of_slider_stories_to_show == 0 ? 5 : number_of_slider_stories_to_show) + number_of_collections_to_show + number_of_child_stories_to_show
            return limit
            
        case .some(.sevenMediaStories7s),
             .some(.amoebaSliderNs),
             .some(.fourStoryHalfFeatured4s),
             .some(.gradientCardsFourStory4s),
             .some(.fiveStory1AD1Wid),
             .some(.oneCarouselTwoStoriesOneAdOneWidget7s),
             .some(.fiveStoryOneAd),
             .some(.fourStoryPhotoGallery),
             .some(.twelveStory1AD1Wid),
             .some(.sliderFocusedCardNs),
             .some(.threeStroySliderRound),
             .some(.ninteenStories1Ad),
             .some(.invertedFourStoryHalfFeatured),
             .some(.twelveStoriesOneAd12s),
             .some(.vikatanTV):
            limit = number_of_stories_to_show != 0 ? number_of_stories_to_show : number_of_child_stories_to_show
            return limit
            
            
        case .some(.magazineSubscriptionSliderNc),
             .some(.UNKNOWN):
            limit = 5
            return limit
        
        case .some(.twoCollection4Story),
             .some(.fourStoryTwoCol_FourStoryOneAdOneWidget),
             .some(.sixteenStory4c):
            limit = number_of_collections_to_show + number_of_stories_to_show
            return limit
        
       
        
        }
    }
    
    private enum CollectionLayout:String {
        
        case mainRowWithBundle12s5c1ad = "main-row-with-bundle-12s-5c-1ad"
        case sevenMediaStories7s = "seven-media-stories-7s"
        case amoebaSliderNs = "amoeba-slider-ns"
        case sixteenStory4c = "sixteen-story-4c"
        case sliderFocusedCardNs = "slider-focused-card-ns"
        
        case fourStoryHalfFeatured4s = "four-story-half-featured-4s"
        case invertedFourStoryHalfFeatured = "inverted-four-story-half-featured-4s"
        case gradientCardsFourStory4s = "gradient-cards-four-story-4s"
        case magazineSubscriptionSliderNc = "magazine-subscription-slider-nc"
        case oneCarouselTwoStoriesOneAdOneWidget7s = "one-carousel-two-stories-one-ad-one-widget-7s"
        
        case fiveStoryOneAd = "five-story-one-ad"
        case twoCollection4Story = "two-collection-four-story"
        case ninteenStories1Ad = "nineteen-stories-one-ad-19s"
        case fiveStory1AD1Wid = "five-story-one-ad-one-widget"
        
        case threeStroySliderRound = "three-story-slider-round"
        case fourStoryPhotoGallery = "four-story-photo-gallery"
        case twelveStory1AD1Wid = "twelve-stories-one-ad-one-widget-12s"
        case fourStoryTwoCol_FourStoryOneAdOneWidget = "4S-2C4S-1Ad-1Widget"
        
        case twelveStoriesOneAd12s = "twelve-stories-one-ad-12s"
        case vikatanTV = "vikatan-tv"

        case UNKNOWN = ""
        
        var shouldFetchInnerCollection: Bool  {
            switch self {
            case .sixteenStory4c, .fourStoryTwoCol_FourStoryOneAdOneWidget, .twoCollection4Story:
                return true
            default:
                return false
            }
        }
        
    }
}



