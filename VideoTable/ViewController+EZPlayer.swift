import UIKit
import AVFoundation
import AVKit
import EZPlayer
import TweenKit
import NVActivityIndicatorView



extension ViewController:EZPlayerDelegate{
        
    
    
    // MARK: - EZPlayerDelegate
    public func playerHeartbeat(_ player: EZPlayer) {
    }
    
    public func player(_ player: EZPlayer, playerDisplayModeDidChange displayMode: EZPlayerDisplayMode) {
    }
    
    public func player(_ player: EZPlayer, playerStateDidChange state: EZPlayerState) {
        print("state:",state)
    }
    
    public func player(_ player: EZPlayer, bufferDurationDidChange bufferDuration: TimeInterval, totalDuration: TimeInterval) {
    }
    
    public func player(_ player: EZPlayer, currentTime: TimeInterval, duration: TimeInterval) {
    }
    
    public func player(_ player: EZPlayer, playerControlsHiddenDidChange controlsHidden: Bool, animated: Bool) {
    }
    
    public func player(_ player: EZPlayer ,showLoading: Bool){
    }
    
}

