//
//  Layout.swift
//  CoreiOS
//
//  Created by Albin CR on 12/8/16.
//  Copyright © 2016 Albin CR. All rights reserved.
//

import Foundation

public class Layout:SafeJsonObject{
    
    public var stories_between_stacks:NSNumber?
    public var menu:[Menu] = []
    public var stacks:[Stack] = []
    override public func setValue(_ value: Any?, forKey key: String) {
    
        if key == "menu" {
           
            for section in value as! [[String:AnyObject]]{
                 let singleMenu = Menu()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleMenu.setValuesForKeys(data)
                    self.menu.append(singleMenu)
                    
                })
            }
        }else  if key == "stacks" {
            
            for section in value as! [[String:AnyObject]]{
                let singleStacks = Stack()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleStacks.setValuesForKeys(data)
                    self.stacks.append(singleStacks)
                    
                })
            }
            
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
}


