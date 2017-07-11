import UIKit
import EZPlayer
import AVFoundation

struct MediaItem {
    var url: URL?
    var title: String?
}


class MediaManager {
     var player: EZPlayer?
     var transisitonPlayer: EZPlayer?
     var mediaItem: MediaItem?
     var embeddedContentView: UIView?
  
    weak var weakSkin:EZPlayerCustomSkin?
    
    

    
    static let shared = MediaManager()
 


    func playEmbeddedVideo(url: URL, embeddedContentView contentView: UIView? = nil, userinfo: [AnyHashable : Any]? = nil) {
        var mediaItem = MediaItem()
        mediaItem.url = url
        self.playEmbeddedVideo(mediaItem: mediaItem, embeddedContentView: contentView, userinfo: userinfo )

    }

    func playEmbeddedVideo(mediaItem: MediaItem, embeddedContentView contentView: UIView? = nil , userinfo: [AnyHashable : Any]? = nil ) {
        //stop
        self.releasePlayer()
        
        let skin = EZPlayerCustomSkin()
        skin.configureForTheatreMode()
        self.weakSkin = skin
       // self.player = EZPlayer(controlView: skin)
         self.player = EZPlayer()
        
        if let autoPlay = userinfo?["autoPlay"] as? Bool{
            self.player!.autoPlay = autoPlay
        }
        
        if let fullScreenMode = userinfo?["fullScreenMode"] as? EZPlayerFullScreenMode{
            self.player!.fullScreenMode = fullScreenMode
        }
        
        self.player!.backButtonBlock = { fromDisplayMode in
            if fromDisplayMode == .embedded {
                self.releasePlayer()
            }else if fromDisplayMode == .fullscreen {
                if self.embeddedContentView == nil && self.player!.lastDisplayMode != .float{
                    self.releasePlayer()
                }
                
            }else if fromDisplayMode == .float {
                self.releasePlayer()
            }
            
        }
        
        self.embeddedContentView = contentView
        
        self.player!.playWithURL(mediaItem.url! , embeddedContentView: self.embeddedContentView)
    }




    
    func releasePlayer(){
            self.player?.stop()
            self.player?.view.removeFromSuperview()
        
        self.player = nil
        self.embeddedContentView = nil
        self.mediaItem = nil

    }
    
   




}
