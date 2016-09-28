//
//  WebDetailVC.swift
//  Gank
//
//  Created by Huway Mac on 16/9/28.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit

class WebDetailVC:ViewController{
    
    var url :String = ""
    
    lazy var webV:UIWebView = {
        let w = UIWebView()
        return w
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webV)
        webV.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func loadUrl(url:String){
        if let nsurl = NSURL(string: url){
            webV.loadRequest(NSURLRequest(URL: nsurl))
        }
    }
    
}