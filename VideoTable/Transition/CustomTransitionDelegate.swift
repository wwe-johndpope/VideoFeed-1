
import UIKit

enum TransitionStatus {
    case present
    case dismiss
}

class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var presentPanGesture: UIPanGestureRecognizer?
    var dismissPanGesture: UIPanGestureRecognizer?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransition()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let presentPanGesture = presentPanGesture {
            return CustomInterectivityTransition(status: .present, presentPan: presentPanGesture)
        }
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let dismissPanGesture = dismissPanGesture {
            return CustomInterectivityTransition(status: .dismiss, dismissPan: dismissPanGesture)
        }
        return nil
    }
}
