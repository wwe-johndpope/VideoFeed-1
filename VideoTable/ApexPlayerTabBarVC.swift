import UIKit
import Dotzu
import AVFoundation


let floatFrame: CGRect = {
    CGRect(x: UIScreen.main.bounds.size.width - 213 - 20, y: UIScreen.main.bounds.size.height - 120 - 60, width: 213, height: 120)
}()

let minimizedOrigin: CGPoint = {
    let x = UIScreen.main.bounds.width / 2 - 10
    let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
    let coordinate = CGPoint(x: x, y: y - 50)
    return coordinate
}()

class ApexPlayerTabBarVC:UIViewController{
    
    let mainTBC = UITabBarController()
    var customTransitionDelegate = CustomTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Main tab bars
        mainTBC.viewControllers = self.buildNavigationControllers()
        addChildViewController(mainTBC)
        view.addSubview(mainTBC.view)
        mainTBC.didMove(toParentViewController: self)
  
        
    }
    
    func handOverPlayer(layer:AVPlayerLayer,indexPath:IndexPath,urls:[String]){

        let theatreModeVC = ViewController()
        theatreModeVC.urls = urls
        theatreModeVC.isTheatreMode = true
        theatreModeVC.transitioningDelegate = customTransitionDelegate
        let nc = UINavigationController(rootViewController: theatreModeVC)
        nc.navigationBar.isTranslucent = false
        theatreModeVC.navigationItem.leftBarButtonItem = CloseButtonItem(target: self, action: #selector(self.dismissVC))
        DispatchQueue.main.async {
            self.present(nc, animated: true) {}
            theatreModeVC.handOverPlayer(layer: layer, indexPath: indexPath)
        }
 
        
    }
    
    
    func dismissVC(){
        
        self.dismiss(animated: true) {
            
        }
    }
        
    

    // when the filterByVc pop up shows - need to correct it after it closes
    func addObservers(){
        
    }


     func resyncStatusBarColor(){
        Logger.verbose("resyncStatusBarColor")
    }
    

    func buildNavigationControllers() -> [UIViewController]{
        
        // Tab 1
        let feedsNC = UINavigationController()
        feedsNC.navigationBar.isTranslucent = false
        feedsNC.tabBarItem = self.tabBarItem(title: "Test", imageName: "icon_featured", selectedImageName: "icon_featured", tagIndex: 0)
        let feedsVC = ViewController()
        feedsVC.view.backgroundColor = .yellow
        feedsNC.viewControllers = [feedsVC]
        
        // tab 2
        let test2 = UIViewController()
        test2.tabBarItem = self.tabBarItem(title: "Test2", imageName: "icon_featured", selectedImageName: "icon_featured", tagIndex: 0)
        let test3 = UIViewController()
        test3.tabBarItem = self.tabBarItem(title: "Test3", imageName: "icon_featured", selectedImageName: "icon_featured", tagIndex: 0)
        let test4 = UIViewController()
        test4.tabBarItem = self.tabBarItem(title: "Test4", imageName: "icon_featured", selectedImageName: "icon_featured", tagIndex: 0)
        let test5 = UIViewController()
        test5.tabBarItem = self.tabBarItem(title: "Test5", imageName: "icon_featured", selectedImageName: "icon_featured", tagIndex: 0)

        return [feedsNC,test2,test3,test4,test5]
        
    }
    
  
    func tabBarItem(title: String, imageName: String, selectedImageName: String, tagIndex: Int) -> UITabBarItem {
        let item = UITabBarItem(title: title,
                                         image: UIImage(named: imageName),
                                         selectedImage: UIImage(named: selectedImageName))
        item.tag = tagIndex
        return item
    }
    
    
    
    
       
}

