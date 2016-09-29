//
//  ChatTableVC.swift
//  Gank
//
//  Created by Huway Mac on 16/9/29.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit

class ChatTableVC :UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    lazy var tableV :UITableView  = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    lazy var tfInput : UITextField = {
        let tf = UITextField()
        tf.backgroundColor  = UIColor.darkGrayColor()
        tf.delegate = self
        return tf
    }()
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.addNew()
        
        self.view.endEditing(true)
        self.tfInput.resignFirstResponder()
        
        return  true
    }
    
    
    lazy var chatArray = Array<ChatDataBean>()
    var selfUid : Int = 10000
    var  chatCell = ChatRightCell()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "快说!", style: .Done, target: self, action: #selector(ChatTableVC.addNew))
        
        self.ka_startObservingKeyboardNotifications()
        
        
        tableV.registerClass(ChatLeftCell.self, forCellReuseIdentifier: ChatLeftCell.reuseId)
        tableV.registerClass(ChatRightCell.self, forCellReuseIdentifier: ChatRightCell.reuseId)
        
        view.addSubview(tableV)
        view.addSubview(tfInput)
        tableV.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
            make.bottom.equalTo(view).offset(-50)
        }
        tfInput.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(50)
            make.bottom.equalTo(view)
        }
        buildDataList()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.ka_startObservingKeyboardNotifications()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.ka_stopObservingKeyboardNotifications()
    }
    
    override func ka_keyboardWillShowOrHideWithHeight(height: CGFloat, animationDuration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        // 键盘动画
        tfInput.snp_updateConstraints{
            m in
            m.left.equalTo(self.view)
            m.right.equalTo(self.view)
            m.bottom.equalTo(self.view).offset(-height)
            m.height.equalTo(49)
        }
        
        tableV.snp_updateConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(view).offset(-height - 50)
        }
        
        tfInput.setNeedsUpdateConstraints()
        tfInput.updateConstraintsIfNeeded()
        
        tableV.setNeedsUpdateConstraints()
        tableV.updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseOut, animations: {
            self.tableV.layoutIfNeeded()
            self.tfInput.layoutIfNeeded()
            }, completion:{b in
                if b {
                    let nsIndex = NSIndexPath(forItem: self.chatArray.count - 1, inSection: 0)
                    self.tableV.scrollToRowAtIndexPath( nsIndex , atScrollPosition: .Bottom, animated: true)
                }
        })
    }
    
    
    func buildDataList() {
        chatArray.append(getNewChat("历历万乡", uid: 10086, content: "若有天我不复勇往 能否坚持走完这一场 踏遍万水千山总有一地故乡"))
        chatArray.append(getNewChat("历历万乡", uid: 10086, content: "城市慷慨亮整夜光  如同少年不惧岁月长"))
        chatArray.append(getNewChat("走马", uid: selfUid, content:"  窗外雨都停了  屋里灯还黑着数着你的冷漠   把玩着寂寞 "))
        chatArray.append(getNewChat("走马", uid: selfUid, content:"   过了很久终于我愿抬头看   你就在对岸走得好慢"))
        chatArray.append(getNewChat("历历万乡", uid: 10086, content: "她想要的不多只是和别人的不一样  烛光倒影为我添茶"))
        chatArray.append(getNewChat("走马", uid: selfUid, content:" 任由我独自在假寐与现实之间两难 "))
    }
    
    func addNew(){
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        let inputContent = tfInput.text
        if ((chatArray.count % 3) == 0){
            chatArray.append(getNewChat("走马", uid: selfUid , content:"新来的 \(strNowTime) \(inputContent!)"))
        }else{
            chatArray.append(getNewChat("历历万乡", uid: 10086 , content:"你对你对你都对 \(strNowTime) \(inputContent!)"))
        }
        tableV.reloadData()
        let nsIndex = NSIndexPath(forItem: chatArray.count - 1, inSection: 0)
        tableV.scrollToRowAtIndexPath( nsIndex , atScrollPosition: .Bottom, animated: true)
    }
    
    func getNewChat(nick:String,uid:Int,content:String) -> ChatDataBean {
        let chatData = ChatDataBean()
        chatData.content = content
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        chatData.date = strNowTime
        
        chatData.uid = uid
        chatData.nick = nick
        return chatData
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = chatArray[indexPath.row]
        return chatCell.getContentHeight(data.content)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let data = chatArray[indexPath.row] as? ChatDataBean{
            if(data.uid == selfUid){
                if let leftCell = tableV.dequeueReusableCellWithIdentifier(ChatLeftCell.reuseId) as? ChatLeftCell{
                    leftCell.bindData(data)
                    return leftCell
                }
            }else{
                if let rightCell = tableV.dequeueReusableCellWithIdentifier(ChatRightCell.reuseId) as? ChatRightCell{
                    rightCell.bindData(data)
                    return rightCell
                }
            }
        }
        
        return UITableViewCell()
    }
    
    
    
}