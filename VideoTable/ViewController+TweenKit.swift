import Foundation
import TweenKit
import Dotzu


// Encapsulates logic to provide smooth scrolling en par with facebook theatremode
// This is (ONLY) invoked when the video finishes playing / it reached it's completed duration.
// Code below currently uses relative calculations depending on scroll offset.
// The scheduler has a sequence of actions that get executed.
// N.B. if user scrolls the scheduler will remove any pending actions.

extension ViewController{
    
   
    func smoothScroll(_ yOffset:CGFloat){
        let pt = CGPoint(x:0,y:yOffset)
        self.myTableView.contentOffset = pt
    }
    
    
    // TODO - get the global pt of clicked cell then offset scrollview from currently playing
    func smoothScrollToIndex(indexPath:IndexPath){
        
    }
    
    func scrollToNextVideo(){
        if (self.isDraggingDeceleratingOrTrackingAndScrolling()){ return}
        
        if let _ = nextPlayableCellIndex(){
            print("scrollToNextVideo")
            let offsetY = self.myTableView.contentOffset.y
            
            let cellHeight = 300 + 20 + 10 + offsetY
            let scrollDownSmooth = InterpolationAction(from: CGFloat(offsetY),
                                                       to: CGFloat(cellHeight),    duration: 0.7,  easing: .sineOut) {  [unowned self] in
                                                        self.smoothScroll($0)
            }
            // auto trigger new movie to play
            let endBlock = RunBlockAction {
                [unowned self] in
                self.resetVisibleIndex()
               
                
            }
            
            let sequence = ActionSequence(actions:
                [scrollDownSmooth,
                 endBlock ])
            
            scheduler.run(action: sequence)
            
        }else{
            Logger.warning("no next playable cell")
        }
        
        
    }
    
    // We want to prevent the avplayer being injected when dragging / scrolling and lazily load after user stops
    // N.B. - when the user flicks really fast - then clicks really fast - there's an edge case that needs to be
    // accommodated. the did select row at index isn't  called correctly. the isTracking + isFlicking fixes this
    func isDraggingDeceleratingOrTrackingAndScrolling() -> Bool{
        print("---------------------------")
        var abort = false
        if(self.myTableView.isDragging == true && self.myTableView.isDecelerating == true){
            abort = true
        }
        
        if(self.myTableView.isTracking == true && self.isFlicking == true){
            return false
        }
        
        if(self.myTableView.isTracking == true){
            abort = true
        }
        return abort
        
        
    }
}


