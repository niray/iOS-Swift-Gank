import Foundation
import UIKit
import SnapKit

class ChatLeftCell : UITableViewCell {
    
    static var reuseId :String = "leftCell"
    
  internal lazy var lbl_nick : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.lightGrayColor()
        lbl.font = UIFont.boldSystemFontOfSize(12)
        return lbl
    }()
    
  internal lazy var lbl_content : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFontOfSize(16)
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lbl_nick)
        contentView.addSubview(lbl_content)
        
        lbl_nick.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.left.equalTo(self.contentView).offset(10)
        }
        
        lbl_content.snp_makeConstraints { (make) in
            make.top.equalTo(self.lbl_nick).offset(20)
            make.left.equalTo(self.contentView).offset(8)
            make.bottom.equalTo(self.contentView).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData(data:ChatDataBean ){
        lbl_nick.text = "\(data.nick) \(data.date)"
        lbl_content.text = data.content
    }
    
    
}
