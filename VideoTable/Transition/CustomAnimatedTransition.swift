import UIKit

class CustomAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let offsetY: CGFloat = 0
        let presentedViewWidth = containerView.bounds.width
        let presentedViewHeight = containerView.bounds.height
        
        

        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if let toViewController = toViewController, let toView = toView, toViewController.isBeingPresented {
            containerView.addSubview(toView)
            let initialFrame = containerView.frame
            toView.frame = initialFrame.offsetBy(dx: 0, dy: containerView.bounds.height)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                toView.frame = CGRect(x: 0, y: offsetY, width: presentedViewWidth, height: presentedViewHeight)
                }, completion: { _ in
                    let isCancelled = transitionContext.transitionWasCancelled
                    transitionContext.completeTransition(!isCancelled)
            })
        }
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        if let fromeViewController = fromViewController, let fromeView = fromView, fromeViewController.isBeingDismissed {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut], animations: { 
                fromeView.alpha = 0
                fromeView.frame = fromeView.frame.offsetBy(dx: 0, dy: presentedViewHeight)
                }, completion: { _ in
                    let isCancelled = transitionContext.transitionWasCancelled
                    transitionContext.completeTransition(!isCancelled)
            })
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
}
