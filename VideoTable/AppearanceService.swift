import Foundation
import UIKit
import Material

// Base appearance protocol
protocol AppearanceProtocol {
    var tintColor: UIColor { get }
    var unselectedTintColor: UIColor? { get }
    var barTintColor: UIColor? { get }
    var isTranslucent: Bool { get }
}

// Status appearance protocol & struct
protocol StatusBarAppearanceProtocol: AppearanceProtocol {}
extension StatusBarAppearanceProtocol {
    var tintColor: UIColor { return UIColor.white }
    var unselectedTintColor: UIColor? { return nil }
    var barTintColor: UIColor? { return .cyan }
    var isTranslucent: Bool { return false }
}

struct StatusBarAppearance: NavigationBarAppearanceProtocol {}

// Navigation appearance protocol & struct
protocol NavigationBarAppearanceProtocol: AppearanceProtocol {}
extension NavigationBarAppearanceProtocol {
    var tintColor: UIColor { return .white }
    var unselectedTintColor: UIColor? { return .yellow }
    var barTintColor: UIColor? { return .black }
    var isTranslucent: Bool { return false }
}

struct NavigationBarAppearance: NavigationBarAppearanceProtocol {}

// TabBar appearance protocol & struct
protocol TabBarAppearanceProtocol: AppearanceProtocol {}
extension TabBarAppearanceProtocol {
    var tintColor: UIColor { return .white }
    var unselectedTintColor: UIColor? { return UIColor(white: 1, alpha: 0.7) }
    var barTintColor: UIColor? { return .black }
    var isTranslucent: Bool { return false }
}

struct TabBarAppearance: TabBarAppearanceProtocol {}

final class AppearanceService {
    static let shared = AppearanceService()
    
    let statusBar = StatusBarAppearance()
    let navBar = NavigationBarAppearance()
    let tabBar = TabBarAppearance()
    
    func setGlobalAppearance() {
        // NavigationBar
        let navAppearance = UINavigationBar.appearance()
        navAppearance.tintColor = navBar.tintColor
        navAppearance.barTintColor = navBar.barTintColor
        navAppearance.isTranslucent = navBar.isTranslucent
        navAppearance.titleTextAttributes = [NSFontAttributeName: RobotoFont.medium(with: 20),
                                             NSForegroundColorAttributeName: UIColor.white]
        
        // Text fields
        let searchAppearance = UISearchBar.appearance()
        searchAppearance.backgroundColor = .black
        searchAppearance.tintColor = .red
        searchAppearance.barTintColor = .white
        searchAppearance.searchBarStyle = .minimal
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = RobotoFont.medium(with: 20)
        
        
        
        // UITabBar
        let tabBarAppearance = UITabBar.appearance()
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        let cgSize = CGSize(width:(screenWidth)/5,height: 49)
        UITabBar.appearance().selectionIndicatorImage =  getImageWithColorPosition(color: .red, size: cgSize, lineSize: CGSize(width:(screenWidth)/5, height:2))
        
        
       
        
        tabBarAppearance.tintColor = tabBar.tintColor
        if #available(iOS 10.0, *) {
            tabBarAppearance.unselectedItemTintColor = tabBar.unselectedTintColor
        } else {
            // Fallback on earlier versions
        }
        tabBarAppearance.barTintColor = tabBar.barTintColor
        tabBarAppearance.isTranslucent = tabBar.isTranslucent
        
        // left / right navigation buttons
        UIBarButtonItem.appearance().tintColor = .white
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight),
             NSForegroundColorAttributeName: UIColor.white], for: .normal)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight),
                                                             NSForegroundColorAttributeName: UIColor.lightGray], for: .disabled)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(
            [NSFontAttributeName: RobotoFont.medium(with: 20),
             NSForegroundColorAttributeName: UIColor.white], for: .normal)
        
        // StatusBar
        UIApplication.shared.statusBarStyle = .lightContent
        guard let statusView = UIApplication.shared.value(forKey: "statusBar") as? UIView else {
            return
        }
        
        statusView.backgroundColor = statusBar.barTintColor
    }
    

    class func setBarButtonItemAppearance() {
        
    }
    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        let rect = CGRect(x:10, y: 0, width: size.width - 20.0, height: size.height)
        
        let rectLine = CGRect(x:10, y:size.height-lineSize.height,width: lineSize.width - 20.0,height: lineSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    
}
