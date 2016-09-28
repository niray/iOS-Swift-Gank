//
//  GankTableVC.swift
//  Gank
//
//  Created by Huway Mac on 16/9/27.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class GankTableVC:UITableViewController{
    
    var API_MEIZHI = "http://gank.io/api/search/query/listview/category/%E7%A6%8F%E5%88%A9/count/10/page/"
    
    var page:Int = 1
    var mzArray = Array<JSON>()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let nib = UINib(nibName: "MZTableCell",bundle: nil)//cell文件名
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        self.tableView.registerClass(HandByHandCell.self, forCellReuseIdentifier: "hbhCell")
        
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.requestData( self.page )
            debugPrint("request Refresh")
        })
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.requestData(self.page)
            debugPrint("request load")
        })
        requestData(1)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint(indexPath.row)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mzArray.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 450.0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let c = tableView.dequeueReusableCellWithIdentifier("hbhCell") as? HandByHandCell{
            let data = mzArray[indexPath.row]
            c.updateCellDate(data)
            return c
        }
        return UITableViewCell()
    }
    
    //请求数据
    func requestData(p:Int){
        Alamofire.request(.GET,"\(API_MEIZHI)\(p)")
            .responseData { (resp:Response<NSData, NSError>) in
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                switch resp.result{
                case .Success(let data):
                    if(self.page==1){
                        self.mzArray.removeAll()
                    }
                    
                    let json = JSON(data:data)
                    if let arr = json["results"].array{
                        self.mzArray.appendContentsOf(arr)
                    }
                    
                    self.page = self.page + 1
                    self.tableView.reloadData()
                case .Failure(let error):
                    debugPrint(error.localizedDescription)
                }
        }
    }
}
