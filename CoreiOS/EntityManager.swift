//
//  EntityManager.swift
//  Pods
//
//  Created by Arjun P A on 04/07/17.
//
//

import Foundation
import Unbox

public class EntityManager:NSObject{

    var httpInstance:Http!
    var mapper:[String:Entity.Type] = [:]
    
    public init(http:Http = Http.sharedInstance, mapperPara:[String:Entity.Type]) {
        self.httpInstance = http
        self.mapper = mapperPara
        super.init()
    }
    
    
    
    func getStoryEntitiesSerialized(story:Story, completion:@escaping (Story) -> Void){
        
        let filteredCards = story.cards.filter({$0.metadata != nil && $0.metadata?.storyAttributes != nil && $0.metadata!.storyAttributes!.count > 0})
        
        if filteredCards.count == 0{
            let managedStory = manageStoryLevelEntities(storyObject: story)
            completion(managedStory)
            return
            
        }
        
        var cardIDEntityIDMapping:[Int:String] = [:]
        
       _ = filteredCards.map { (card) -> Card in
            let storyAttributes = card.metadata!.storyAttributes!
            for (_, value) in storyAttributes{
                if let keyValueAttribute = value as? [AnyObject]{
                    for object in keyValueAttribute{
                        let id = object["id"] as! NSNumber
                        cardIDEntityIDMapping[id.intValue] = card.id ?? ""
                    }
                }
            }
            return card
        }
        
        let allKeys = Array(cardIDEntityIDMapping.keys)
        
        getEntitiesSerialized(ids: allKeys, endpoint: nil) { (entityModels) in
            
            for entityModel in entityModels{
                if let cardID = cardIDEntityIDMapping[entityModel.id]{
                    
                    story.cards = story.cards.map({ (targetCard) -> Card in
                        if targetCard.id ?? "" == cardID{
                            let entityStoryElement = self.renderEntityAsStoryElement(model: entityModel)
                            targetCard.story_elements.insert(entityStoryElement, at: 0)
                            cardIDEntityIDMapping[entityModel.id] = nil
                        }
                        return targetCard
                    })
                }
                else{
                    continue
                }
            }
            let handledStory = self.manageStoryLevelEntities(storyObject: story)
            completion(handledStory)
            
        }
    }
    
    fileprivate func manageStoryLevelEntities(storyObject:Story) -> Story{
        guard let metadata = storyObject.storyMetadata else{return storyObject}
        guard let storyAttributes = metadata.story_attributes else{return storyObject}
        guard let linkedEntties = storyObject.linked_entities else{return storyObject}
        
        for (_, attr) in storyAttributes{
            if let entityArray = attr as? [[String:AnyObject]]{
                for entityAttr in entityArray{
                    let id = (entityAttr["id"] as! NSNumber).intValue
                    let filteredEntity = linkedEntties.filter({ (unserializedEntity) -> Bool in
                        let idEn = unserializedEntity["id"] as! NSNumber
                        return idEn.intValue == id
                    })
                    if let firstEntity = filteredEntity.first{
                        guard let modeledEntity = self.modelEntityWithJSONObject(object: firstEntity) else{continue}
                        let newCard = Card()
                        newCard.id = generateUUID()
                        newCard.story_elements.append(renderEntityAsStoryElement(model: modeledEntity))
                        storyObject.cards.insert(newCard, at: 0)
                    }
                    else{
                        continue
                    }
                }
            }
        }
        return storyObject
    }
    
    func generateUUID() -> String{
        return UUID().uuidString
    }
    
    
    func renderEntityAsStoryElement(model:Entity) -> CardStoryElement{
        let element = CardStoryElement()
        element.type = "entity"
        element.subtype = "card-entity"
        element.userData = model
        return element
    }
    
    
    public func getEntitiesSerialized(ids:[Int], endpoint:String? = nil, completion: @escaping (_ data:[Entity]) -> Void){
        getEntities(ids: ids, endpoint: endpoint) { (entityObjects) in
            var allEntities:[Entity] = []
            for entityObject in entityObjects{
                if let modeledEntity = self.modelEntityWithJSONObject(object: entityObject as! [String:AnyObject]){
                    allEntities.append(modeledEntity)
                }
            }
            
            completion(allEntities)
        }
        
    }
    
    fileprivate func modelEntityWithJSONObject(object:[String:AnyObject]) -> Entity?{
        if let entityModel:Entity = try? unbox(dictionary: object){
            
            let type = entityModel.type
            
            if let mappingExist = self.mapper[type!]{
                if let actualModel = try? mappingExist.init(unboxer: Unboxer.init(dictionary: object )){
                   return actualModel
                }
                else{
                    return entityModel
                }
            }
            else{
                return entityModel
            }
        }
        return nil
    }
    
    
    
    
    public func getEntities(ids:[Int], endpoint:String? = nil, completion: @escaping (_ data:[AnyObject]) -> Void){
        let allIds = ids.map({"\($0)"}).joined(separator: ",") as NSString
        
        let endPointURL = endpoint ?? (Constants.urlConfig.getBaseUrl() + Constants.urlConfig.entityBulkURL)
        
        self.httpInstance.call(method: "get", urlString: endPointURL, parameter: ["ids":allIds], cache: cacheOption.none, Success: { (result) in
            if let entityArray = result?["result"] as? [AnyObject]{
                completion(entityArray)
            }
        }, Error: { (error) in
            
        })
    }
    
}
