import Foundation
import UIKit

extension UIWindow {
    public class func window() -> UIWindow {
        return UIWindow(frame: UIScreen.main.bounds)
    }
}


extension IndexPath{
    
    func isValid() -> Bool
    {
        if( self.section >= 0){
            if (self.row >= 0){
                return true
            }
        }
        
        return false
    }
}
