import UIKit
import AVFoundation
import AVKit
import EZPlayer
import TweenKit
import NVActivityIndicatorView



var currentlyPlayingIndex:IndexPath = IndexPath(row:-1,section:0)
var lastPlayingIndex:IndexPath = IndexPath(row:-1,section:0)

class ViewController: UIViewController{
    
    lazy var myTableView:UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        return tb
    }()
    
    var isFlicking = false
    var handoverIndexPath:IndexPath?
    var isHandingOver = false
    let scheduler = ActionScheduler()
    var urls : [String] = []

    var isResettingCenteredIndex = false
    var isTheatreMode = false
    var handOverLayer:AVPlayerLayer?
    
    func delayedRefresh(){
        self.resetVisibleIndex()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.playbackFinished(_:)), name: NSNotification.Name.EZPlayerPlaybackDidFinish, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addObservers()
        
        self.title = "Title"
        
        // Snapkit layouts
        self.view.addSubview(myTableView)
        myTableView.separatorColor = .gray
        myTableView.backgroundColor = .black
        myTableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        myTableView.snp.remakeConstraints { (make) -> Void in
            make.width.height.top.equalToSuperview()
        }
        myTableView.register(VideoItemTableViewCell.self, forCellReuseIdentifier: VideoItemTableViewCell.ID)
        myTableView.register(HandoverVideoItemTableViewCell.self, forCellReuseIdentifier: HandoverVideoItemTableViewCell.ID2)
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.view.backgroundColor = .black
        
        // init URLs
        urls = ["https://vziptvapi.azurewebsites.net/assets/stream/output/VZ_reConnect.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/VZ_Fear.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/VZ_NFL.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/VZ_Marching_Band.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/transformers%20dark%20of%20the%20moon%20(2011).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/Everyday.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/real%20steel%20(2011).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/In%20The%20Loop.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/iron%20man%203%20(2013).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/nba.2013.03.27.chicago.bulls.vs.miami.heat.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/the%20hobbit%20an%20unexpected%20journey%20(2012).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/sherlock%20holmes%20a%20game%20of%20shadows%20(2012).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/one%20for%20the%20money%20(2012).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/fa.cup.2013.04.01.chelsea.vs.manchester.united.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/kung%20fu%20panda%202%20(2011).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/ufc.on.fx.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/ncaa.football.2012.09.15.alabama.vs.arkansas.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/super%208%20(2011).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/Game%20of%20Thrones.S03E01.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/sportscenter.year.in.review.2010.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/the%20amazing%20spider-man%20(2012).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/nfl.afc.championship.2013.01.20.ravens.vs.patriots.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/300%20-%20Rise%20of%20an%20Empire%20(2014).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/hbo.boxing.pacquaio.vs.bradley.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/the%20adventures%20of%20tintin%20(2011).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/mlb.2012.08.07.tigers.vs.yankees.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/nhl.2013.02.24.avalanche.vs.ducks.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/the%20avengers%20(2012).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/mission%20impossible%20-%20ghost%20protocol%20(2011).mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/Psych.S06E01.mp4.m3u8",
                "https://vziptvapi.azurewebsites.net/assets/stream/output/tron%20legacy%20(2010).mp4.m3u8"]

        self.myTableView.reloadData()
        
        let idx = IndexPath(row: 0, section: 0)
        self.playMovie(indexPath:idx)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.resetVisibleIndex()
    }
    
    func handOverPlayer(layer:AVPlayerLayer,indexPath:IndexPath){
        isHandingOver = true
        handoverIndexPath = indexPath
        handOverLayer = layer
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isHandingOver{
            if let handoverIndexPath = handoverIndexPath{
                self.myTableView.scrollToRow(at: handoverIndexPath, at: .middle, animated: false)
                self.myTableView.reloadData()
                
                if let cell = myTableView.cellForRow(at: handoverIndexPath) as? HandoverVideoItemTableViewCell{
                    if let handOverLayer = handOverLayer{
                        cell.rebuildPlayerViewInjectLayer(layer: handOverLayer)
                    }
                }
            }
            
        }
        
        
    }
    
    func invalidateCurrentlyPlayingIndex(){
        currentlyPlayingIndex = IndexPath(row:-1,section:0)
        
    }
    // TODO - not working.
    func snapShotImage(){
        if let image = MediaManager.shared.player?.snapshotImage() {
            
            if let cell = self.myTableView.cellForRow(at: lastPlayingIndex) as? VideoItemTableViewCell{
                print("we got an image!!")
                
                cell.heroImageView.image = image
                cell.setNeedsDisplay()
            }
        }else{
            print("FAIL")
        }
    }

    
}

