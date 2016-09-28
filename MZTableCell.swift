//
//  MZTableCell.swift
//  Gank
//
//  Created by Huway Mac on 16/9/27.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class MZTableCell: UITableViewCell {
    
    @IBOutlet weak var iv_show: UIImageView!
    @IBOutlet weak var lbl_txt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCellDate(data:JSON){
        if let u = data["url"].string{
            iv_show.kf_setImageWithURL(NSURL(string: u)!, placeholderImage:nil )
        }
        lbl_txt?.text="who:\(data["who"])  desc:\(data["desc"])  type:\(data["type"])"
    }
    
}
