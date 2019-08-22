//
//  GalleryImage.swift
//  Quintype
//
//  Created by Pavan Gopal on 12/15/17.
//

import Foundation

open class GalleryImage{
    
    open var imageMeta:ImageMetaData?
    open var image:String?
    open var imageDescription:String?
    open var showAd: Bool = false
    open var currentIndex: Int = 0

    public init() {
        
    }
    
}
