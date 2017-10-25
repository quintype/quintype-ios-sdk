import UIKit
import Quintype

class ViewController: UIViewController,CollectionListLayoutDelegate {
    
    var layoutManager: CollectionListLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeBullkAPiCalls()
      
        
    }
    
    func makeBullkAPiCalls(){
         layoutManager  = CollectionListLayout(slug: "home", delegate: self, storyLimit: 4)
        layoutManager?.make()
    }
    
    func didFetchRenderableCollections(renderables:[RenderableCollection]){
        print(renderables)
    }
    
    func errorOccurred(error:Error){
        
    }
    
}
