import UIKit
import AVFoundation
import AVKit
import EZPlayer
import TweenKit
import NVActivityIndicatorView



extension ViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.isFlicking = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
        self.isFlicking = false
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scheduler.removeAll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetVisibleIndex()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        resetVisibleIndex()
    }
    
    func forceContentToScrollToMiddleOfCell(){
        
        if (currentlyPlayingIndex.isValid()){
            self.myTableView.scrollToRow(at: currentlyPlayingIndex, at: .middle, animated: true)
        }
    }
    
 
    
    func nextPlayableCellIndex()->IndexPath?{
        let nextRow = currentlyPlayingIndex.row + 1
        let nextRowIndexPath = IndexPath(row:nextRow,section:currentlyPlayingIndex.section)
        let totalRows = self.myTableView.numberOfRows(inSection: currentlyPlayingIndex.section)
        if (totalRows > nextRow){
            return nextRowIndexPath
        }else{
            return nil
        }
    }
    
   

    func updateCurrentIndex() -> IndexPath? {
        //when scroll end get the current display off set
        let visibleStartPoint = self.myTableView.contentOffset
        
        // hack on the first entry into vc when we haven't yet scrolled and the first movie should play
        if(visibleStartPoint.y < 300/2){
            if (currentlyPlayingIndex == lastPlayingIndex){
              return  IndexPath(row:0,section:0)
            }
        }
        //calculate the center point in view
        let selectionPoint = CGPoint(x:self.myTableView.frame.width/2,y: visibleStartPoint.y + self.myTableView.frame.height/2)
        //get the index path in center position
        let pt = CGPoint(x:selectionPoint.x,y: selectionPoint.y)
        if let indexPath = self.myTableView.indexPathForRow(at:pt){
            return indexPath
        }
        return nil
    }
    
    func resetVisibleIndex(){
        if (self.isDraggingDeceleratingOrTrackingAndScrolling())
        {
            print("aborting injecting into cell")
            return
        }
        
        isResettingCenteredIndex = true
        if let idx = updateCurrentIndex(){
            if(currentlyPlayingIndex != idx){
                
                if (currentlyPlayingIndex.isValid()){
                    self.snapShotImage()
                }
                lastPlayingIndex = currentlyPlayingIndex
                currentlyPlayingIndex = idx
                if let cell = myTableView.cellForRow(at: currentlyPlayingIndex) as? VideoItemTableViewCell{
                    
                    if let url = URL(string: urls[currentlyPlayingIndex.row] ){
                        
                        print("displayMode:",MediaManager.shared.player?.displayMode ?? "")
                        if(MediaManager.shared.player?.displayMode != .float){
                            MediaManager.shared.playEmbeddedVideo(url:url, embeddedContentView: cell.heroImageView)
                            MediaManager.shared.player?.delegate = self
                            MediaManager.shared.player?.indexPath = currentlyPlayingIndex
//                            MediaManager.shared.player?.scrollView = myTableView
                        }
                    }
                }
                
                
            }
        }
        isResettingCenteredIndex = false
    }
    
    
    
    
   func playbackFinished(_ note: Notification) {
        if let info = note.userInfo as? Dictionary<String,EZPlayerPlaybackDidFinishReason> {
            if( info["EZPlayerPlaybackDidFinishReasonKey"] == EZPlayerPlaybackDidFinishReason.playbackEndTime){
                print("should auto play next video")
                
                if(MediaManager.shared.player?.displayMode == .fullscreen){
                    print("TODO - jump out of landscape mode")
                }else   if(MediaManager.shared.player?.displayMode == .float){
                    if let nextCellIndex = nextPlayableCellIndex(){
                        if let url = URL(string: urls[nextCellIndex.row] ){
                            MediaManager.shared.player?.switchFloatingPlayerVideo(url)
                        }
                    }else{
                        print("TODO - close player")
                    }
                }else{
                    scrollToNextVideo()
                }
            }
        }
    }
    
    func playMovie(indexPath:IndexPath){
        if(currentlyPlayingIndex == indexPath){
            print("is currently playing")
            return
        }
        
        if let cell = myTableView.cellForRow(at: indexPath) as? VideoItemTableViewCell{
//            cell.contentView.backgroundColor = .red
            if let url = URL(string: urls[indexPath.row] ){
                currentlyPlayingIndex = indexPath
                MediaManager.shared.playEmbeddedVideo(url:url, embeddedContentView: cell.heroImageView)
                MediaManager.shared.player?.delegate = self
                MediaManager.shared.player?.indexPath = currentlyPlayingIndex
//                MediaManager.shared.player?.scrollView = myTableView
            }
        }
    }
    
    
    
}

