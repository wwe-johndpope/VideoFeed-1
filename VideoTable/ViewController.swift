import UIKit
import AVFoundation
import AVKit
import EZPlayer
import TweenKit
import NVActivityIndicatorView



var currentlyPlayingIndex:IndexPath = IndexPath(row:-1,section:0)
var lastPlayingIndex:IndexPath = IndexPath(row:-1,section:0)

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,EZPlayerDelegate{
    
    lazy var myTableView:UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        return tb
    }()
    
    
    let scheduler = ActionScheduler()
    var urls : [String] = []

    var isResettingCenteredIndex = false
    
    
    func delayedRefresh(){
        self.resetVisibleIndex()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.playbackFinished(_:)), name: NSNotification.Name.EZPlayerPlaybackDidFinish, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addObservers()
        
        // Snapkit layouts
        self.view.addSubview(myTableView)
        myTableView.separatorColor = .gray
        myTableView.backgroundColor = .white
        myTableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        myTableView.snp.remakeConstraints { (make) -> Void in
            make.width.height.top.equalToSuperview()
        }
        myTableView.register(VideoItemTableViewCell.self, forCellReuseIdentifier: VideoItemTableViewCell.ID)
        myTableView.dataSource = self
        myTableView.delegate = self
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(300.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:VideoItemTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: VideoItemTableViewCell.ID) as? VideoItemTableViewCell
        if (cell == nil){
            cell = VideoItemTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: VideoItemTableViewCell.ID)
        }
        cell!.indexPath = indexPath
        
        // TODO - Doesn't work??
       // if let url = URL(string: urls[indexPath.row] ){
        //   cell?.heroImageView.image = UIFactory.getPreViewImage(url: url)
       // }
       
        return cell! ;
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scheduler.removeAll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetVisibleIndex()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        resetVisibleIndex()
    }
    
    func forceContentToScrollToMiddleOfCell(){
        
        if (currentlyPlayingIndex.isValid()){
            self.myTableView.scrollToRow(at: currentlyPlayingIndex, at: .middle, animated: true)
        }
    }
    
    func smoothScroll(_ yOffset:CGFloat){
        let pt = CGPoint(x:0,y:yOffset)
        self.myTableView.contentOffset = pt
    }
    
    func nextPlayableCellIndex()->IndexPath?{
        let nextRow = currentlyPlayingIndex.row + 1
        let nextRowIndexPath = IndexPath(row:nextRow,section:currentlyPlayingIndex.section)
        let totalRows = self.myTableView.numberOfRows(inSection: currentlyPlayingIndex.section)
        if (totalRows > nextRow){
            return nextRowIndexPath
        }else{
            return nil
        }
    }
    
    func scrollToNextVideo(){
        if(!isResettingCenteredIndex){
            
            if let _ = nextPlayableCellIndex(){
                let offsetY = self.myTableView.contentOffset.y
                
                let scrollDownSmooth = InterpolationAction(from: CGFloat(offsetY),
                                      to: CGFloat(offsetY+300),    duration: 1.3,  easing: .sineOut) {  [unowned self] in
                                                            self.smoothScroll($0)
                }
                // auto trigger new movie to play
                let endBlock = RunBlockAction {
                    [unowned self] in
                    self.resetVisibleIndex()
                }
                
                let sequence = ActionSequence(actions:
                    [scrollDownSmooth,
                     endBlock ])
                
                scheduler.run(action: sequence)
            }
           
        }
        
    }
    
    func updateCurrentIndex() -> IndexPath? {
        //when scroll end get the current display off set
        let visibleStartPoint = self.myTableView.contentOffset
        
        // hack on the first entry into vc when we haven't yet scrolled and the first movie should play
        if(visibleStartPoint.y < 300/2){
            if (currentlyPlayingIndex == lastPlayingIndex){
              return  IndexPath(row:0,section:0)
            }
        }
        //calculate the center point in view
        let selectionPoint = CGPoint(x:self.myTableView.frame.width/2,y: visibleStartPoint.y + self.myTableView.frame.height/2)
        //get the index path in center position
        let pt = CGPoint(x:selectionPoint.x,y: selectionPoint.y)
        if let indexPath = self.myTableView.indexPathForRow(at:pt){
            return indexPath
        }
        return nil
    }
    
    func resetVisibleIndex(){
        isResettingCenteredIndex = true
        if let idx = updateCurrentIndex(){
            if(currentlyPlayingIndex != idx){
                
                if (currentlyPlayingIndex.isValid()){
                    self.snapShotImage()
                }
                lastPlayingIndex = currentlyPlayingIndex
                currentlyPlayingIndex = idx
                if let cell = myTableView.cellForRow(at: currentlyPlayingIndex) as? VideoItemTableViewCell{
                    
                    if let url = URL(string: urls[currentlyPlayingIndex.row] ){
                        
                        print("displayMode:",MediaManager.shared.player?.displayMode ?? "")
                        if(MediaManager.shared.player?.displayMode != .float){
                            MediaManager.shared.playEmbeddedVideo(url:url, embeddedContentView: cell.contentView)
                            MediaManager.shared.player?.delegate = self
                            MediaManager.shared.player?.indexPath = currentlyPlayingIndex
                            MediaManager.shared.player?.scrollView = myTableView
                        }
                    }
                }
                
                
            }
        }
        isResettingCenteredIndex = false
    }
    
    
   func playbackFinished(_ note: Notification) {
        if let info = note.userInfo as? Dictionary<String,EZPlayerPlaybackDidFinishReason> {
            if( info["EZPlayerPlaybackDidFinishReasonKey"] == EZPlayerPlaybackDidFinishReason.playbackEndTime){
                print("should auto play next video")
                
                if(MediaManager.shared.player?.displayMode == .fullscreen){
                    print("TODO - jump out of landscape mode")
                }else   if(MediaManager.shared.player?.displayMode == .float){
                    if let nextCellIndex = nextPlayableCellIndex(){
                        if let url = URL(string: urls[nextCellIndex.row] ){
                            MediaManager.shared.player?.switchFloatingPlayerVideo(url)
                        }
                    }else{
                        print("TODO - close player")
                    }
                }else{
                    scrollToNextVideo()
                }
            }
        }
    }
    
    func playMovie(indexPath:IndexPath){
        if let cell = myTableView.cellForRow(at: indexPath) as? VideoItemTableViewCell{
            cell.contentView.backgroundColor = .red
            if let url = URL(string: urls[indexPath.row] ){
                MediaManager.shared.playEmbeddedVideo(url:url, embeddedContentView: cell.contentView)
                MediaManager.shared.player?.delegate = self
                MediaManager.shared.player?.indexPath = currentlyPlayingIndex
                MediaManager.shared.player?.scrollView = myTableView
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.playMovie(indexPath: indexPath)
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

