//
//  MenuGroupModel.swift
//  Vikatan
//
//  Created by Sunil on 22/03/19.
//  Copyright © 2019 Pavan Gopal. All rights reserved.
//

import Foundation
public final class MenuGroupModel:SafeJsonObject
{
    public var id : NSNumber?
    public var slug: String?
    public var name: String?
    public var items:[MenuItems] = []
    override public func setValue(_ value: Any?, forKey key: String)
    {
        if key == "items" {
            
            for section in value as! [[String:AnyObject]]{
                let singleMenu = MenuItems()
                Converter.jsonKeyConverter(dictionaryArray: section, completion: { (data) in
                    singleMenu.setValuesForKeys(data)
                    self.items.append(singleMenu)
                    
                })
            }
        }
        else
        {
        super.setValue(value, forKey: key)
            
        }
    }
    
}
public final class MenuItems:SafeJsonObject
{
    public var tag_name:String?
    public var item_id:NSNumber?
    public var rank:NSNumber?
    public var title:String?
    public var item_type:String?
    public var section_slug:String?
    public var tag_slug:String?
    public var id:NSNumber?
    public var parent_id:NSNumber?
    public var url:String?
    public var section_name:String?
    public var data:MenuData?
    public var imageString:UIImage?
    public var collection_id: NSNumber?
    override public func setValue(_ value: Any?, forKey key: String)
    {
        if key == "data"{
            
            data = MenuData()
            Converter.jsonKeyConverter(dictionaryArray: value as? [String : AnyObject], completion: { (data) in
                self.data?.setValuesForKeys(data)
                
            })
        }
        else
        {
        super.setValue(value, forKey: key)
        }
    }
    
    public func getMenu() -> Menu {
        let menu = Menu()
        menu.id = self.id
        menu.item_id = self.item_id
        menu.item_type = self.item_type
        menu.parent_id = self.parent_id
        menu.tag_name = self.tag_name
        menu.section_slug = self.section_slug
        menu.section_name = self.section_name
        menu.title = self.title
        let meta = MenuMeta()
        meta.color = self.data?.color
        menu.data = meta
        return menu
    }
    
}
public final class MenuData:SafeJsonObject
{
    public var color:String?
    public var icon_code:String?

}
