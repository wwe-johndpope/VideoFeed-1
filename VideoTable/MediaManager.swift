import UIKit
import EZPlayer

struct MediaItem {
    var url: URL?
    var title: String?
}


class MediaManager {
     var player: EZPlayer?
     var mediaItem: MediaItem?
     var embeddedContentView: UIView?

    static let shared = MediaManager()
    private init(){


    }

    func playEmbeddedVideo(url: URL, embeddedContentView contentView: UIView? = nil, userinfo: [AnyHashable : Any]? = nil) {
        var mediaItem = MediaItem()
        mediaItem.url = url
        self.playEmbeddedVideo(mediaItem: mediaItem, embeddedContentView: contentView, userinfo: userinfo )

    }

    func playEmbeddedVideo(mediaItem: MediaItem, embeddedContentView contentView: UIView? = nil , userinfo: [AnyHashable : Any]? = nil ) {
        //stop
        self.releasePlayer()
        
        if let skinView = userinfo?["skin"] as? UIView{
         self.player =  EZPlayer(controlView: skinView)
        }else{
          self.player = EZPlayer()
        }
        
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
