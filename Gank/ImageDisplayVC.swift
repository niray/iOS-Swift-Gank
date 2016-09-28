//
//  ImageDisplayVC.swift
//  Gank
//
//  Created by Huway Mac on 16/9/28.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyJSON

class ImageDisplayVC :UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    let screenW = UIScreen.mainScreen().bounds.width
    let screenH = UIScreen.mainScreen().bounds.height
    
    var currentIndex : Int = 0
    
    lazy var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.screenW, height: self.screenH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        let cetV = UICollectionView(frame: CGRectZero, collectionViewLayout:layout  )
        cetV.delegate = self
        cetV.dataSource = self
        cetV.pagingEnabled = true
        return cetV
        
    }()
    
    var mzArray = Array<JSON>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false // 手动控制全屏
        
        self.view.addSubview(cv)
        cv.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        cv.registerClass(MZDisplayCell.self, forCellWithReuseIdentifier: "cell")
        
        cv.reloadData()
//        let nsIndex = NSIndexPath(forItem: currentIndex, inSection: 0)
//        cv.selectItemAtIndexPath(nsIndex, animated: false, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        // 显示用户选中的页
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cv.selectItemAtIndexPath(NSIndexPath(forItem: currentIndex, inSection:0), animated: false, scrollPosition: .CenteredHorizontally)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mzArray.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        debugPrint(indexPath.item)
        cv.selectItemAtIndexPath(NSIndexPath(forItem: currentIndex, inSection:0), animated: false, scrollPosition: .CenteredHorizontally)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let c = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? MZDisplayCell{
            let data = mzArray[indexPath.item] 
            if let u = data["url"].string{
                c.ivShow.kf_setImageWithURL(NSURL(string: u)!, placeholderImage:nil)
            }
            return c
        }
        return UICollectionViewCell()
    }
    
    
}