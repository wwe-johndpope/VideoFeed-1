import Foundation
import UIKit
import SnapKit
import Material
import Dotzu
import AVFoundation


class HandoverVideoItemTableViewCell:VideoItemTableViewCell {
    static  let ID2 = "HandoverVideoItemTableViewCell"
    
    
    // BEGIN - To support seemless transition of one avplayer to another
    var runOnce = false
    var playerLayer:AVPlayerLayer?
    
    var videoPlayer:AVPlayer = AVPlayer.init()
    lazy var playerView:SnapkitPlayerView = {
        let playerView = SnapkitPlayerView.init(frame:.zero)
        return playerView
    }()
    
    
}

