//
//  Downloader.swift
//  Quintype
//
//  Created by Albin CR on 3/30/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//

import Foundation
import UIKit
//import Kingfisher
//import KingfisherWebP

//open class ImageObject{
//    
//    public var imageURL:String?
//    public var imageMetaData:ImageMetaData?
//    
//}

open class Downloader:NSObject,URLSessionDelegate,URLSessionDownloadDelegate{
    
    public typealias completion = () -> ()
    public var tellAppDelegateHandleEventsForBackgroundURLSessionIsCompleted:completion?
    
//    public typealias sendImageObjectBack = ([ImageObject]) -> ()
//    
//    public var ch : sendImageObjectBack?
    
    var backgroundSession :URLSession?
    var url:URL?
    
    override init(){
        super.init()
        
        createInstance()
        
    }
    
    func createInstance(){
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.downloade.storage")
        config.isDiscretionary = true
        backgroundSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    public func Download(url:String){
        
        self.url = URL(string: url)
        let requestDownload = URLRequest(url: self.url!)
        let downloadTask = self.backgroundSession?.downloadTask(with: requestDownload)
        downloadTask?.resume()
        
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print(session,"asdasd")
        
        let fileManager = FileManager.default
        
        if  let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            
            let fileName = "ofline.json"
            
            let desinationURL = documentDirectory.appendingPathComponent(fileName)
            
            do {
                _ = try fileManager.replaceItemAt(desinationURL, withItemAt:location)
                
                if let data = readJson(fileName: desinationURL){
                    
                    Cache.cacheData(data: data, key: (self.url?.absoluteString)!, cacheTimeInMinute: 12 * 60, cacheType: Constants.cache.cacheToMemoryAndDiskWithTime,oflineStatus: true)

                }
            }
            catch let error { print("Ooops! cannot read: \(error)") }
            
        }
    }
    private func readJson(fileName:URL) -> [String:Any]? {
        do {
            
            let data = try Data(contentsOf: fileName)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let object = json as? [String: Any] {
                
                ApiParser.StoriesParser(data: object as [String : AnyObject]?, completion: { (stories) in
                    
                    
                    for story in stories{
                        
                        if story.hero_image_s3_key != nil{
                            
                           // get image pass to KF
                            //get story id
                            
                        }
                        
                    }
//                    self.ch?(//)
                })

                return object
            }else{
                return nil
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite) * 100)
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let someError = error{
            NSLog("error:%@",someError as NSError)
        }
        else{
            NSLog("hurray something happened")
        }
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        tellAppDelegateHandleEventsForBackgroundURLSessionIsCompleted?()
        
    }
    
    
}

