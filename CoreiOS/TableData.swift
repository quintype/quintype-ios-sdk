//
//  TableData.swift
//  Pods
//
//  Created by Arjun P A on 20/06/17.
//
//

import Foundation

public class TableData:SafeJsonObject, NSCopying{
    
    public var content:String!
    public var contentType:String!
    public var parsedData:Array<Array<String>> = []
    public var filteredData:Array<Array<String>>?
     override public func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let newData = TableData()
        newData.content = self.content
        newData.contentType = self.contentType
        newData.parsedData = self.parsedData
        return newData
    }

}
