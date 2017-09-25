import UIKit
import Quintype


//enum collectionTypes:String{
//
//    case collection = "collection"
//    case story = "story"
//
//}
class ViewController: UIViewController {
    
    
    var storyCollection:[String:[Story]] = [:]
    
    var deepDive = 4
    var count = 0
    var bulkLimit = 6
    
    let bulkFields:[String] = ["id","headline","slug","url","hero-image-s3-key","hero-image-metadata","first-published-at","last-published-at","alternative","published-at","author-name","author-id","sections","story-template","summary","metadata"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Quintype.initWithBaseUrl(baseURL: "https://www.thequint.com")
        
        _ = BulkApi().BulkCall(Slug: "home", deepDive: deepDive, bulkFields: bulkFields, bulkLimit: bulkLimit, cache: cacheOption.cacheToDiskWithTime(min: 0), Error: { (error) in
            
            print(error)
            
        }) { (storyArray) in
            
            for (_,i) in storyArray.enumerated(){
                
                for (_,j) in i.value.enumerated(){
                    
                    print(j.headline ?? "")
                    
                }
            }
        }
        
    }
    
}
