import UIKit
import AVFoundation
import AVKit
import EZPlayer
import TweenKit
import NVActivityIndicatorView


extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(300.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // when we go to theatremode - use a special cell that will have an avplayer layer to hand over to
        if(self.isHandingOver && indexPath == handoverIndexPath){
            self.isHandingOver = false
            var cell:HandoverVideoItemTableViewCell?

            if (cell == nil){
                cell = HandoverVideoItemTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: HandoverVideoItemTableViewCell.ID2)
            }
            cell!.indexPath = indexPath
            return cell!
            
        }
        var cell:VideoItemTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: VideoItemTableViewCell.ID) as? VideoItemTableViewCell
        if (cell == nil){
            cell = VideoItemTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: VideoItemTableViewCell.ID)
        }
        if isTheatreMode{
            cell?.contentView.backgroundColor = .red
        }
        cell!.indexPath = indexPath
        

       
        return cell! ;
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if(indexPath == currentlyPlayingIndex){
            self.invalidateCurrentlyPlayingIndex()
            MediaManager.shared.releasePlayer()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isTheatreMode{
            self.playMovie(indexPath: indexPath)
            return
        }
        
        // find the player layer
        if let cell = tableView.cellForRow(at: indexPath){
            for view in cell.subviews{
                
                for subView in view.subviews{
                    if let playerLayer = subView.layer  as? AVPlayerLayer{
                        print("we found a subView.layer")
                        DataManager.shared.weakApexTabBarVC?.handOverPlayer(layer: playerLayer,indexPath:indexPath,urls:urls)
                        return
                    }
                }
            }
        }
  
    }
    
    
}

