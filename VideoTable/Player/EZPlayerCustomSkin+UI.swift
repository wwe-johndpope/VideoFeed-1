
import UIKit
import AVFoundation
import MediaPlayer
import SnapKit
import EZPlayer
import Material
import Dotzu



class EZPlayerCustomSkin: UIView{
    weak public var player: EZPlayer?{
            didSet{
                player?.setControlsHidden(false, animated: true)
                self.autohideControlView()
            }
    }
    

    let kPlayerEdgePadding = 20
    let kButtonHeight = 41

    
    var hideControlViewTask: Task?

    // maintain mispelling to conform to Ezplayer
    public var autohidedControlViews = [UIView]()


    var timeLabel = UILabel()
    var titleLabel = UILabel()
    
    var fullEmbeddedScreenButtonPressed = UIButton()
    var fullEmbeddedScreenButton = UIButton()
    
    var gradientImageView = UIImageView(frame: .zero)
    
    var playPauseContainerView = UIView(frame:.zero)
    var playPauseButton = IconButton(image: UIImage(named:"playButton"), tintColor: .white)
    var goForwardButton = IconButton(image: UIImage(named:"goForward"), tintColor: .white)
    var goBackwardButton = IconButton(image: UIImage(named:"goBack"), tintColor: .white)
    
    let moreButton =  IconButton(image: Icon.cm.moreVertical, tintColor: .lightGray)
    let fullscreenButton = IconButton(image: UIImage(named:"fullscreen"), tintColor: .white)
    let minimizePlayer = IconButton(image: UIImage(named:"miniplayer"), tintColor: .white)
    
    lazy var timeSlider:UISlider = {
        let p = UISlider(frame: .zero)
        p.clipsToBounds = true
        p.maximumTrackTintColor = UIColor.init(white: 1, alpha: 0.4)
        p.minimumTrackTintColor = .purple
        return p
    }()
    
    var videoshotPreview =  UIView()
    var videoshotImageView = UIImageView()

    var loading = CustomLoading()

    
    lazy var progressView:UIProgressView = {
        let p = UIProgressView(frame: .zero)
        p.progressViewStyle = .bar
        p.clipsToBounds = true
        p.progressTintColor = UIColor.init(white: 1, alpha: 0.4)
        p.trackTintColor = .red
        return p
    }()
    
    
    var isProgressSliderSliding = false {
        didSet{
            if !(self.player?.isM3U8 ?? true) {
                //self.videoshotPreview.isHidden = !isProgressSliderSliding
            }
        }
        
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        loading.weakSkin = self
    }
    
   
    

    override init(frame: CGRect) {
        super.init(frame:frame)

        // Scrubber ImageView
        self.addSubview(videoshotPreview)
        videoshotPreview.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(106)
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
        videoshotPreview.addSubview(videoshotImageView)
        videoshotImageView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        
        // Bottom Gradient
        gradientImageView.image = UIImage(named: "videoGradientOverlay")
        self.addSubview(gradientImageView)
        gradientImageView.isUserInteractionEnabled = false
        gradientImageView.snp.remakeConstraints { (make) -> Void in
            make.left.width.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom)
        }
        
        // Progress View
        self.addSubview(progressView)
        self.progressView.snp.remakeConstraints { (make) -> Void in
            make.width.bottom.left.equalToSuperview()
            make.height.equalTo(3)
        }
        self.progressView.progress = 0
        self.progressView.progressTintColor = UIColor.blue
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.backgroundColor = UIColor.clear
        
        // Kebab
        self.addSubview(moreButton)
        moreButton.snp.remakeConstraints { (make) -> Void in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        // Container
        self.addSubview(playPauseContainerView)
        playPauseContainerView.backgroundColor = .clear
        playPauseContainerView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        // Play Pause
        playPauseContainerView.addSubview(playPauseButton)
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        playPauseButton.snp.remakeConstraints { (make) -> Void in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(62)
        }

        // go foward 10 seconds
        playPauseContainerView.addSubview(goForwardButton)
        goForwardButton.snp.remakeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalTo(playPauseButton.snp.right).offset(10)
            make.height.width.equalTo(kButtonHeight)
        }
        goForwardButton.addTarget(self, action: #selector(seekForward), for: .touchUpInside)
        
        // go back 10 seconds
        playPauseContainerView.addSubview(goBackwardButton)
        goBackwardButton.snp.remakeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalTo(playPauseButton.snp.left).offset(-10)
            make.height.width.equalTo(kButtonHeight)
        }
        goBackwardButton.addTarget(self, action: #selector(seekBackward), for: .touchUpInside)
        
        

        
        // Time Label 0:00
        self.addSubview(timeLabel)
        timeLabel.textColor = .white
        timeLabel.font = RobotoFont.medium(with: 11)
        timeLabel.text = "0:00"
        timeLabel.snp.remakeConstraints { (make) -> Void in
            make.bottom.equalToSuperview()
            make.right.equalTo(self.moreButton.snp.left).offset(-10)
            make.width.equalTo(65)
            make.height.equalTo(20)
        }
        
        // Minimize
        self.addSubview(minimizePlayer)
        minimizePlayer.snp.remakeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(kPlayerEdgePadding)
            make.left.equalToSuperview().offset(kPlayerEdgePadding)
        }
        minimizePlayer.addTarget(self, action: #selector(dockPlayerPressed), for: .touchUpInside)
        
        // Fullscreen
        self.addSubview(fullscreenButton)
        fullscreenButton.snp.remakeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(kPlayerEdgePadding)
            make.right.equalToSuperview().offset(-kPlayerEdgePadding)
        }
        fullscreenButton.addTarget(self, action: #selector(fullEmbeddedScreenButtonPressed(_:)), for: .touchUpInside)
        
        
        // Time slider
        self.timeSlider.value = 0
        self.timeSlider.addTarget(self, action: #selector(progressSliderTouchEnd(_:)), for: .touchCancel)
        self.timeSlider.addTarget(self, action: #selector(progressSliderTouchBegan(_:)), for: .touchDown)
        self.timeSlider.addTarget(self, action: #selector(progressSliderTouchEnd(_:)), for: .touchUpInside)
        self.timeSlider.addTarget(self, action: #selector(progressSliderTouchEnd(_:)), for: .touchUpOutside)
        self.timeSlider.addTarget(self, action: #selector(progressSliderValueChanged(_:)), for: .valueChanged)
        
        self.addSubview(self.timeSlider)
        self.timeSlider.snp.remakeConstraints { (make) -> Void in
            make.right.equalTo(self.timeLabel.snp.left).offset(-kPlayerEdgePadding)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(kPlayerEdgePadding)
        }
        
    
        //

        // Loading
        self.addSubview(self.loading)
        self.loading.snp.remakeConstraints { (make) -> Void in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }

        self.autohidedControlViews = []
        self.hidePlayPauseForwardBack()
  
    }
    
    // Used by loading to ensure play + loading controls don't overlap
    func showPlayPauseForwardBack(){
        print("showPlayPauseForwardBack")
        playPauseButton.isHidden = false
        goForwardButton.isHidden = false
        goBackwardButton.isHidden = false
    }
    
    func hidePlayPauseForwardBack(){
        print("hidePlayPauseForwardBack")
        playPauseButton.isHidden = true
        goForwardButton.isHidden = true
        goBackwardButton.isHidden = true
    }
    
    func togglePlayPause(){
        Logger.verbose("togglePlayPause")
        if( MediaManager.shared.player?.player?.rate == 0){
            self.playPauseButton.image = UIImage(named:"pause")
            MediaManager.shared.player?.player?.play()
        }else{
            self.playPauseButton.image = UIImage(named:"playButton")
            MediaManager.shared.player?.player?.pause()
        }
    }
    
    // Remove all the controls on screen
    func configureForFeeds(){
        self.playPauseContainerView.isHidden = true
        self.playPauseButton.isHidden = true
        self.goForwardButton.isHidden = true
        self.goBackwardButton.isHidden = true
        self.timeSlider.isHidden = true
        self.fullscreenButton.isHidden = true
        self.minimizePlayer.isHidden = true
        self.gradientImageView.isHidden = true
        self.timeLabel.isHidden = true
        self.moreButton.isHidden = true
        self.progressView.isHidden = false
        self.autohidedControlViews = []
    }
 
 
    func configureForTheatreMode(){
      
        self.fullscreenButton.isHidden = false
        self.minimizePlayer.isHidden = false
        self.autohidedControlViews = [self.gradientImageView,self.timeSlider,self.fullscreenButton,
                                      self.minimizePlayer,self.timeLabel,
                                      self.playPauseContainerView,self.moreButton]
    }
    
    
    func dockPlayerPressed(){
      
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func seekForward() {
        Logger.verbose("seekForward")
        if let time = MediaManager.shared.player?.currentTime{
           MediaManager.shared.player?.seek(to: time + 10,completionHandler:nil)
        }
        
        
    }
    
    func seekBackward( ) {
         Logger.verbose("seekBackward")
        if let time = (MediaManager.shared.player?.currentTime){
            MediaManager.shared.player?.seek(to: time - 10,completionHandler:nil)
        }
        
    }

}


// Make the loading adjust the controls visibility when starting / stopping
class CustomLoading: EZPlayerLoading {
    weak var weakSkin:EZPlayerCustomSkin?
    
    override func start(){
        super.start()
        weakSkin?.hidePlayPauseForwardBack()
    }
    
    override func stop(){
        super.stop()
        weakSkin?.showPlayPauseForwardBack()
    }
    
    
}


