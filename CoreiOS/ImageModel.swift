//
//  ImageModel.swift
//  Quintype
//
//  Created by subhajit halder on 28/02/19.
//

import Foundation

open class ImageModel: SafeJsonObject {
    public var type : String?
    public var image_s3_key: String?
    public var image_metadata: ImageMetaData?
}
