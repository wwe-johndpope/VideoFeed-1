//
//  ApexPlayer+Seemless.swift
//  VideoTable
//
//  Created by Pope, John on 7/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import AVFoundation

 //  setup seemless transition player
extension HandoverVideoItemTableViewCell{
    

    
    // When snapkit changes the uiview - the CA layer will be synced.
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!runOnce){
            runOnce = true
            addPlayerLayerAfterViewDidLayout()
        }
        self.syncPlayerViewWithPlayerLayer()
    }
    
    
    // we need to continually update the CA layer to sync with snapkit constraints
    func syncPlayerViewWithPlayerLayer(){
        self.playerLayer?.frame = self.playerView.frame
        self.playerView.setNeedsLayout()
    }
    
    
    // Delay due to snapkit timing otherwise frame = .zero
    func addPlayerLayerAfterViewDidLayout(){
        self.playerLayer = AVPlayerLayer.init(player: self.videoPlayer)
        self.playerView.configureLayer(playerLayer:self.playerLayer!)
    }
    
    // Used when videos are currently playing in main feeds and we want to seemlessly transition
    func injectPlayerViewLayer(player:AVPlayer?,layer:AVPlayerLayer,video:MediaItem?){
        
       self.rebuildPlayerViewInjectLayer(layer:layer)
        
    }
    
    
    // due to side effects stopping and starting player / need to rebuild view
    func rebuildPlayerViewInjectLayer(layer:AVPlayerLayer){
        
        // blow away existing snapkit uiview that has video layer
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.playerView.removeFromSuperview()
        self.playerView = SnapkitPlayerView.init(frame:.zero)
        self.heroImageView.addSubview(self.playerView)
        playerView.snp.remakeConstraints { (make) -> Void in
            make.top.left.right.height.equalToSuperview()
        }
        self.playerLayer = AVPlayerLayer.init(player: self.videoPlayer)
        
        // inject currently playing video into view
        self.playerView.configureLayer(playerLayer:layer)
    }

}
