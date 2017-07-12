import UIKit

class CustomInterectivityTransition: UIPercentDrivenInteractiveTransition {
    var transitionStatus: TransitionStatus
    var presentPanGesture: UIPanGestureRecognizer?
    var dismissPanGesture: UIPanGestureRecognizer?
    var isInteracting: Bool = false
    var transitionContext: UIViewControllerContextTransitioning?
    
    deinit {
        
    }
    init(status: TransitionStatus, presentPan: UIPanGestureRecognizer? = nil, dismissPan: UIPanGestureRecognizer? = nil) {
        presentPanGesture = presentPan
        dismissPanGesture = dismissPan
        transitionStatus = status
        super.init()
        presentPan?.addTarget(self, action: #selector(panGestureRecognizerDidUpdate))
        dismissPan?.addTarget(self, action: #selector(panGestureRecognizerDidUpdate))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    func panGestureRecognizerDidUpdate(_ sender: UIPanGestureRecognizer) {
        
        if let transitionContext = transitionContext{
            
            let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view!
            let translation = sender.translation(in: fromView)
            let offsetY = transitionStatus == .present ? -translation.y : translation.y
            var percent = offsetY / fromView.bounds.height
            percent = min(1.0, max(0, percent))
            
            switch sender.state {
            case .began:
                isInteracting = true
            case .changed:
                update(percent)
            default:
                isInteracting = false
                if percent >= 0.3 {
                    finish()
                } else {
                    cancel()
                }
            }
        }
        
    }
    
}
