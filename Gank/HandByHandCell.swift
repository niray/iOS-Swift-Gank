//
//  HandByHandCell.swift
//  Gank
//
//  Created by Huway Mac on 16/9/28.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftyJSON
import Kingfisher

class HandByHandCell :UITableViewCell{
    
    lazy var iv_avatar :UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var lbl_content : UILabel = {
        let a = UILabel()
        return a
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clipsToBounds = true
        
        self.contentView.addSubview(iv_avatar)
        self.contentView.addSubview(lbl_content)
        
        self.iv_avatar.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-50)
        }
        
        self.lbl_content.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.iv_avatar.snp_bottom).offset(10)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellDate(data:JSON){
        if let u = data["url"].string{
            iv_avatar.kf_setImageWithURL(NSURL(string: u)!, placeholderImage:nil )
        }
        self.lbl_content.text="who:\(data["who"])  desc:\(data["desc"])  type:\(data["type"])"
    }
}