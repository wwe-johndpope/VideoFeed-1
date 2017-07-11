//
//  SnapkitPlayerView.swift
//  wwe-redesign-ios
//
//  Created by Pope, John on 5/4/17.
//  Copyright © 2017 WWE. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


//http://stackoverflow.com/questions/2504151/calayers-didnt-get-resized-on-its-uiviews-bounds-change-why
class SnapkitPlayerView:UIView{
    
    weak var playerLayer:AVPlayerLayer?
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds;
    }
    
    func configureLayer(playerLayer:AVPlayerLayer){
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.playerLayer = playerLayer
        self.layer.addSublayer(playerLayer)
    }
}
