//
//  MZDisplayCell.swift
//  Gank
//
//  Created by Huway Mac on 16/9/28.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit

class MZDisplayCell :UICollectionViewCell{
    
    lazy var ivShow:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFit
        return iv
    }()
    
    let W = UIScreen.mainScreen().bounds.width
    let H = UIScreen.mainScreen().bounds.height
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ivShow)
        ivShow.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}