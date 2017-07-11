
import UIKit
import AVFoundation
import MediaPlayer
import SnapKit
import EZPlayer
 

extension EZPlayerCustomSkin: EZPlayerCustom {
    // MARK: - EZPlayerCustomAction
    public func playPauseButtonPressed(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        if player.isPlaying {
            player.pause()
        }else{
            player.play()
        }
    }
    
    public func fullEmbeddedScreenButtonPressed(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        switch player.displayMode {
        case .embedded:
            player.toFull()
        case .fullscreen:
            if player.lastDisplayMode == .embedded{
                player.toEmbedded()
            }else  if player.lastDisplayMode == .float{
                player.toFloat()
            }
            
        default:
            break
        }
    }
    
     public func audioSubtitleCCButtonPressed(_ sender: Any) {
        guard let player = self.player else {
            return
        }
//        let audibleLegibleViewController = EZPlayerAudibleLegibleViewController(nibName:  String(describing: EZPlayerAudibleLegibleViewController.self),bundle: Bundle(for: EZPlayerAudibleLegibleViewController.self),player:player, sourceView:sender as? UIView)
//        EZPlayerUtils.viewController(from: self)?.present(audibleLegibleViewController, animated: true, completion: {
//            
//        })
    }
    
    
    
     public func backButtonPressed(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        let displayMode = player.displayMode
        if displayMode == .fullscreen {
            if player.lastDisplayMode == .embedded{
                player.toEmbedded()
            }else  if player.lastDisplayMode == .float{
                player.toFloat()
            }
        }
        player.backButtonBlock?(displayMode)
    }
    
    
    // MARK: - EZPlayerGestureRecognizer
    public func player(_ player: EZPlayer, singleTapGestureTapped singleTap: UITapGestureRecognizer) {
        player.setControlsHidden(!player.controlsHidden, animated: true)
        
    }
    
    public func player(_ player: EZPlayer, doubleTapGestureTapped doubleTap: UITapGestureRecognizer) {
        self.playPauseButtonPressed(doubleTap)
    }
    
    // MARK: - EZPlayerHorizontalPan
    public func player(_ player: EZPlayer, progressWillChange value: TimeInterval) {
        if player.isLive ?? true{
            return
        }
        cancel(self.hideControlViewTask)
        self.isProgressSliderSliding = true
    }
    
    public func player(_ player: EZPlayer, progressChanging value: TimeInterval) {
        if player.isLive ?? true{
            return
        }
        self.timeLabel.text = EZPlayerUtils.formatTime(position: value, duration: self.player?.duration ?? 0)
        if !self.timeSlider.isTracking {
            self.timeSlider.value = Float(value)
        }
    }
    
    public func player(_ player: EZPlayer, progressDidChange value: TimeInterval) {
        if player.isLive ?? true{
            return
        }
        self.autohideControlView()
        //        self.isProgressSliderSliding = false
        self.player?.seek(to: value, completionHandler: { (isFinished) in
            self.isProgressSliderSliding = false
            
        })
    }
    
    // MARK: - EZPlayerDelegate
    
    public func playerHeartbeat(_ player: EZPlayer) {
        if let asset = player.playerasset, let  playerIntem = player.playerItem ,playerIntem.status == .readyToPlay{
            if asset.audios != nil || asset.subtitles != nil || asset.closedCaption != nil{
//                self.audioSubtitleCCButtonWidthConstraint.constant = 50
            }else{
//                self.audioSubtitleCCButtonWidthConstraint.constant = 0
            }
        }
//        self.airplayContainer.isHidden = !player.allowsExternalPlayback
    }
    
    
    public func player(_ player: EZPlayer, playerDisplayModeDidChange displayMode: EZPlayerDisplayMode) {
        
    }
    
    public func player(_ player: EZPlayer, playerStateDidChange state: EZPlayerState) {
    
        switch state {
        case .playing ,.buffering:
            self.playPauseButton.isSelected = true
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            
        case .seekingBackward ,.seekingForward:
            break
        default:
           self.playPauseButton.isSelected = false
           self.playPauseButton.setImage(UIImage(named: "playButton"), for: .normal)
            
        }
    }
    
    public func player(_ player: EZPlayer, bufferDurationDidChange bufferDuration: TimeInterval, totalDuration: TimeInterval) {
        if totalDuration.isNaN || bufferDuration.isNaN || totalDuration == 0 || bufferDuration == 0{
            self.progressView.progress = 0
        }else{
            self.progressView.progress = Float(bufferDuration/totalDuration)
        }
    }
    
    public func player(_ player: EZPlayer, currentTime: TimeInterval, duration: TimeInterval) {
        if currentTime.isNaN || (currentTime == 0 && duration.isNaN){
            return
        }
        self.timeSlider.isEnabled = !duration.isNaN
        self.timeSlider.minimumValue = 0
        self.timeSlider.maximumValue = duration.isNaN ? Float(currentTime) : Float(duration)
//        self.titleLabel.text = player.contentItem?.title ?? player.playerasset?.title
        if !self.isProgressSliderSliding {
            self.timeSlider.value = Float(currentTime)
            self.timeLabel.text = duration.isNaN ? "Live" : EZPlayerUtils.formatTime(position: currentTime, duration: duration)
            
        }
    }
    
    func hideProgressView(){
        self.progressView.alpha = 0
    }
    
    func showProgressView(){
        UIView.animate(withDuration: ezAnimatedDuration, delay: 0,options: .curveEaseInOut, animations: {
           self.progressView.alpha = 1
        }, completion: {finished in

            UIView.setAnimationsEnabled(true)
        })
    }
    
    
    public func player(_ player: EZPlayer, playerControlsHiddenDidChange controlsHidden: Bool, animated: Bool) {
        print("playerControlsHiddenDidChange")
        
        if controlsHidden {
            self.hideControlView(animated)
            self.showProgressView()
        }else{
            self.showControlView(animated)
            self.hideProgressView()
        }
    }
    
    public func player(_ player: EZPlayer ,showLoading: Bool){
        if showLoading {
            self.loading.start()
        }else{
            self.loading.stop()
        }
    }
    
    
}


