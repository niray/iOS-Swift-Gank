import Foundation
import UIKit
import SnapKit

class ChatRightCell : UITableViewCell {
    
    static var reuseId :String = "rightCell"
    
    internal lazy var lbl_nick : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .Right
        lbl.textColor = UIColor.blueColor()
        lbl.font = UIFont.boldSystemFontOfSize(12)
        return lbl
    }()
    
    internal lazy var lbl_content : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .Right
        lbl.numberOfLines = 0
        lbl.backgroundColor = UIColor.greenColor()
        lbl.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        lbl.font = UIFont.boldSystemFontOfSize(16)
        return lbl
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(lbl_nick)
        self.contentView.addSubview(lbl_content)
        
        contentView.backgroundColor = UIColor.lightGrayColor()
        
        lbl_nick.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.left.greaterThanOrEqualTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
        }
        
        lbl_content.snp_makeConstraints { (make) in
            make.top.equalTo(self.lbl_nick.snp_bottom).offset(10)
            make.left.greaterThanOrEqualTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData(data:ChatDataBean){
        lbl_nick.text = "\(data.nick) - \(data.date)"
        lbl_content.text = data.content
    }
    
    func getContentHeight(content:String) -> CGFloat{
        lbl_content.text = content
        return lbl_content.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 40
    }
    
}
