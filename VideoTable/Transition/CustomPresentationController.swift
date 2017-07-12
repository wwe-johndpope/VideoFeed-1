import UIKit
import Dotzu

class CustomPresentationController: UIPresentationController {
    
    let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(presentingViewController.view, at: 0)
        containerView?.addSubview(dimmingView)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        dimmingView.alpha = 0
        dimmingView.frame = containerView!.frame
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedDismissPresentedView))
        dimmingView.addGestureRecognizer(tap)
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.4
//            self.presentingViewController.view.layer.cornerRadius = 5
//            self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
            UIApplication.shared.keyWindow?.addSubview(presentingViewController.view)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
            self.presentingViewController.view.layer.cornerRadius = 0
            self.presentingViewController.view.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            UIApplication.shared.keyWindow?.addSubview(presentingViewController.view)
        }
    }
    
    func tappedDismissPresentedView() {
        Logger.verbose("tappedDismissPresentedView")
//        let presentedViewController = self.presentedViewController as! PresentedViewController
//        presentedViewController.TappedDismiss(presentedViewController.dismissButton)
    }
    
}
