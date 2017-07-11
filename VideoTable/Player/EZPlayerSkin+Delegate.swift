
import UIKit
import AVFoundation
import MediaPlayer
import SnapKit
import EZPlayer
import Dotzu


extension EZPlayerCustomSkin{
    

    
    func progressSliderTouchBegan(_ sender: Any) {
        guard let player = self.player else {
            return
        }
        self.player(player, progressWillChange: TimeInterval(self.timeSlider.value))
    }

    func progressSliderValueChanged(_ sender: Any) {
        guard let player = self.player else {
            return
        }

        self.player(player, progressChanging: TimeInterval(self.timeSlider.value))

        if !player.isM3U8 {
            self.videoshotPreview.isHidden = false
            player.generateThumbnails(times:  [ TimeInterval(self.timeSlider.value)],maximumSize:CGSize(width: self.videoshotImageView.bounds.size.width, height: self.videoshotImageView.bounds.size.height)) { (thumbnails) in
                let trackRect = self.timeSlider.convert(self.timeSlider.bounds, to: nil)
                let thumbRect = self.timeSlider.thumbRect(forBounds: self.timeSlider.bounds, trackRect: trackRect, value: self.timeSlider.value)
                var lead = thumbRect.origin.x + thumbRect.size.width/2 - self.videoshotPreview.bounds.size.width/2
                if lead < 0 {
                    lead = 0
                }else if lead + self.videoshotPreview.bounds.size.width > player.view.bounds.width {
                    lead = player.view.bounds.width - self.videoshotPreview.bounds.size.width
                }
//                self.videoshotPreviewLeadingConstraint.constant = lead
                if thumbnails.count > 0 {
                    let thumbnail = thumbnails[0]
                    if thumbnail.result == .succeeded {
                        self.videoshotImageView.image = thumbnail.image
                    }
                }
            }
        }
    }

    func progressSliderTouchEnd(_ sender: Any) {
        self.videoshotPreview.isHidden = true
        guard let player = self.player else {
            return
        }
        self.player(player, progressDidChange: TimeInterval(self.timeSlider.value))
    }



    func hideControlView(_ animated: Bool) {
        if animated{
            UIView.setAnimationsEnabled(false)
            UIView.animate(withDuration: ezAnimatedDuration, delay: 0,options: .curveEaseInOut, animations: {
                self.autohidedControlViews.forEach{
                    $0.alpha = 0
                }
            }, completion: {finished in
                self.autohidedControlViews.forEach{
                    $0.isHidden = true
                }
                UIView.setAnimationsEnabled(true)
            })
        }else{
            self.autohidedControlViews.forEach{
                $0.alpha = 0
                $0.isHidden = true
            }
        }
    }

    func showControlView(_ animated: Bool) {

        if animated{
            UIView.setAnimationsEnabled(false)
            self.autohidedControlViews.forEach{
                $0.isHidden = false
            }
            UIView.animate(withDuration: ezAnimatedDuration, delay: 0,options: .curveEaseInOut, animations: {
                if self.player?.displayMode == .fullscreen{
//                    self.navBarContainerTopConstraint.constant = 20
                }else{
//                    self.navBarContainerTopConstraint.constant = 0
                }
                self.autohidedControlViews.forEach{
                    $0.alpha = 1
                }
            }, completion: {finished in
                self.autohideControlView()
                UIView.setAnimationsEnabled(true)
            })
        }else{
            self.autohidedControlViews.forEach{
                $0.isHidden = false
                $0.alpha = 1
            }
            if self.player?.displayMode == .fullscreen{
//                self.navBarContainerTopConstraint.constant = 20
            }else{
//                self.navBarContainerTopConstraint.constant = 0
            }
            self.autohideControlView()
        }
    }

    func autohideControlView(){
        Logger.verbose("autohideControlView")
        guard let player = self.player , player.autohiddenTimeInterval > 0 else {
            return
        }
        cancel(self.hideControlViewTask)
        self.hideControlViewTask = delay(5, task: { [weak self]  in
            guard let weakSelf = self else {
                return
            }
            weakSelf.player?.setControlsHidden(true, animated: true)
        })


    }

}


