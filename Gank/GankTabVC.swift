//
//  GankTabVC.swift
//  Gank
//
//  Created by Huway Mac on 16/9/28.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class GankTabVC :UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var API_MEIZHI = "http://gank.io/api/search/query/listview/category/%E7%A6%8F%E5%88%A9/count/10/page/"
    var API_GITHUB = "http://gank.io/api/search/query/listview/category/all/count/10/page/"
    
    var page:Int = 1
    var mzArray  = Array<JSON>()
    var gitArray = Array<JSON>()
    
    lazy var segment:UISegmentedControl = {
        let items = ["MeiZhi","Gank"]
        let seg = UISegmentedControl(items:items)
        seg.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(GankTabVC.onTabClick), forControlEvents: .ValueChanged)
        return seg
    }()
    
    lazy var tableView :UITableView = {
        let tv = UITableView(frame: CGRectZero, style: .Grouped)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = segment
        view.addSubview(tableView)
        initMZ()
    }
    
    func onTabClick(){
        debugPrint(segment.selectedSegmentIndex)
        tableView.reloadData()
        if(isFirst()){
            if(self.mzArray.count==0){
                self.page=1
                requestData()
            }
        }else{
            if( self.gitArray.count==0){
                self.page=1
                requestData()
            }
        }
    }
    
    func initMZ(){
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        let nib = UINib(nibName: "MZTableCell",bundle: nil)//cell文件名
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.tableView.registerClass(AutoFitHCell.self, forCellReuseIdentifier: "txtCell")
        self.tableView.registerClass(HandByHandCell.self, forCellReuseIdentifier: "hbhCell")
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.requestData()
            debugPrint("request Refresh")
        })
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.requestData()
            debugPrint("request load")
        })
        
        requestData()
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint(indexPath.row)
        if(isFirst()){
            let iv = ImageDisplayVC()
            iv.mzArray = mzArray
            iv.currentIndex = indexPath.row
            navigationController?.pushViewController(iv, animated: true)
        }else{
            let wv = WebDetailVC()
            let data = gitArray[indexPath.row]
            wv.loadUrl(data["url"].string ?? "")
            navigationController?.pushViewController(wv, animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFirst()){
            return self.mzArray.count
        }else{
            return self.gitArray.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(self.isFirst()){
            return 700.0
        }else{
            let data = gitArray[indexPath.row]
            sampleCell.lbl.text = data["desc"].string
            let size = sampleCell.lbl.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            return size.height + 20
        }
    }
    
    lazy var sampleCell = AutoFitHCell(style: .Default, reuseIdentifier: "")
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(isFirst()){
            if let c = tableView.dequeueReusableCellWithIdentifier("hbhCell") as? HandByHandCell{
                let data = mzArray[indexPath.row]
                c.updateCellDate(data)
                return c
            }
        }else{
            if let c = tableView.dequeueReusableCellWithIdentifier("txtCell") as? AutoFitHCell{
                let data = gitArray[indexPath.row]
                c.lbl.text = data["desc"].string
                return c
            }
        }
        return UITableViewCell()
    }
    
    func isFirst() -> Bool {
        return segment.selectedSegmentIndex == 0
    }
    
    //请求数据
    func requestData(){
        var url:String = API_MEIZHI
        
        if(isFirst()){
            url = API_MEIZHI
        }else{
            url = API_GITHUB
        }
        
        Alamofire.request(.GET,"\(url)\(self.page)")
            .responseData { (resp:Response<NSData, NSError>) in
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                switch resp.result{
                case .Success(let data):
                    if(self.page==1){
                        self.mzArray.removeAll()
                        self.gitArray.removeAll()
                    }
                    
                    let json = JSON(data:data)
                    if let arr = json["results"].array{
                        if(self.isFirst()){
                            self.mzArray.appendContentsOf(arr)
                        }else{
                            self.gitArray.appendContentsOf(arr)
                        }
                    }
                    
                    self.page = self.page + 1
                    self.tableView.reloadData()
                case .Failure(let error):
                    debugPrint(error.localizedDescription)
                }
        }
    }
    
}
