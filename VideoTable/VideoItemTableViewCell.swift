import Foundation
import UIKit
import SnapKit
import Material
import Dotzu


class VideoItemTableViewCell:TableViewCell {
    static  let ID = "VideoItemTableViewCell"
    
    var indexPath:IndexPath?
    let redlineView = UIView(frame:.zero)
    
    let moreButton =  IconButton(image: Icon.cm.moreVertical, tintColor: .lightGray)
    

    lazy var heroImageView:UIImageView = {
        let iv = UIImageView(frame:.zero)
        iv.image = UIImage(named:"placeholder.jpg")
        return iv
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.heroImageView.image = UIImage(named:"placeholder.jpg")

        if(self.hasPlayerInjectedAlready()){
            MediaManager.shared.releasePlayer()
            MediaManager.shared.player?.delegate = nil
        }
        
    }
    
    
    func hasPlayerInjectedAlready()->Bool{
        return Bool(self.heroImageView.subviews.count >= 2)
    }
    

    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = .yellow

        
        // Hero Image
        self.addSubview(self.heroImageView)
        self.heroImageView.removeConstraints((self.imageView?.constraints)!)
        self.heroImageView.snp.remakeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            // cinema ratio
            let ratio = UIScreen.main.bounds.height * 9 / 32
            make.height.equalTo(ratio)
            make.top.left.equalToSuperview()
        }
        // uiimageview is not normally interactive
        self.heroImageView.isUserInteractionEnabled = true

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

