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
    
    lazy var alphaDurationView:UIView = {
        let iv = UIView(frame:.zero)
        return iv
    }()
    
    lazy var heroImageView:UIImageView = {
        let iv = UIImageView(frame:.zero)
        iv.image = UIImage(named:"placeholder")
        return iv
    }()
    
    
    let videoLabel = UILabel(frame: .zero)
    let durationLabel = UILabel(frame: .zero)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        

        
        // Hero Image
        self.addSubview(self.heroImageView)
        self.heroImageView.removeConstraints((self.imageView?.constraints)!)
        self.heroImageView.snp.remakeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(93)
            make.top.left.equalToSuperview()
        }

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

