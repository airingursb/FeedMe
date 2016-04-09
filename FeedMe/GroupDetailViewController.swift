//
//  GroupDetailViewController.swift
//  FeedMe
//
//  Created by Airing on 16/3/23.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import CoreData
import JSONJoy
import SwiftHTTP
import XWSwiftRefresh

class GroupDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var userIds: Array<Int> = []
    var userNames: Array<String> = []
    var replyCreateTimes: Array<String> = []
    var replyContents: Array<String> = []
    var replyIds: Array<Int> = []
    var count: Int = 0
    var pageNumber: Int = 1
    
    var discussId: Int = 0
    var discussUserName: String = ""
    var discussUserHead: String = ""
    var discussContent: String = ""
    var discussImage: String = ""
    var discussCreateTime: String = ""
    
    var dataUtil: DataUtil = DataUtil()
    
    struct Group {
        var userId: Int!
        var userName: String!
        var replyId: Int!
        var replyCreateTime: String!
        var replyContent: String!
        
        init(_ decoder: JSONDecoder) {
            userId = decoder["userId"].integer!
            userName = decoder["userName"].string!
            replyCreateTime = decoder["replyCreateTime"].string!
            replyContent = decoder["replyContent"].string!
            replyId = decoder["replyId"].integer!
        }
    }
    
    struct Groups {
        var result: Int!
        var userName: String!
        var userHead: String!
        var discussContent: String!
        var discussImage: String!
        var discussCreateTime: String!
        var replyNum: Int!
        var groups = [Group]()
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
            userName = decoder["userName"].string!
            userHead = decoder["userHead"].string!
            discussContent = decoder["discussContent"].string!
            discussCreateTime = decoder["discussCreateTime"].string!
            discussImage = decoder["discussImage"].string!
            replyNum = decoder["replyNum"].integer!
            let addrs = decoder["dataList"].array
            for addrDecoder in addrs! {
                groups.append(Group(addrDecoder))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.getDiscuss(self.pageNumber)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableview.reloadData()
                print(self.count)
            });
        });
        
        self.discussId = self.dataUtil.cacheGetInt("discussId")
        
        print("discussId:\(self.discussId)")
        self.tableview.tableFooterView = UIView()
        self.tableview.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDiscuss(pageNumber: Int) {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/show_discuss.action"
        request.POST(discuss_url, parameters: ["page": self.pageNumber, "discussId": self.discussId], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Groups(JSONDecoder(res))
                print(json)
                self.discussUserName = json.userName
                self.discussUserHead = json.userHead
                self.discussContent = json.discussContent
                self.discussImage = json.discussImage
                self.discussCreateTime = json.discussCreateTime
                if (json.result == 1) {
                    if json.replyNum != 0 {
                        for(var i = 0; i < json.replyNum; i++) {
                            self.userIds.append(json.groups[i].userId)
                            self.userNames.append(json.groups[i].userName)
                            self.replyCreateTimes.append(json.groups[i].replyCreateTime)
                            self.replyContents.append(json.groups[i].replyContent)
                            self.replyIds.append(json.groups[i].replyId)
                            self.count++
                            self.tableview.reloadData()
                        }
                    }
                    self.pageNumber++
                    print(self.replyContents)
                } else {
                    print("error")
                }
            }
        })
    }
    
    func downPlullLoadData(){
        
        xwDelay(1) { () -> Void in
            self.getDiscuss(self.pageNumber)
            self.tableview.reloadData()
            self.tableview.footerView?.endRefreshing()
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("row:\(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupTitleCell", forIndexPath: indexPath) as! GroupTitleCell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupTitleCell", forIndexPath: indexPath) as! GroupTitleCell
            
            cell.imgUserHead?.image = UIImage(named: String(self.discussUserHead))
            cell.lblUserName.text = self.discussUserName
            cell.txtContent.text = self.discussContent
            cell.imgGroup?.image = UIImage(named: self.discussImage)
            cell.lblCreateTime.text = self.discussCreateTime
            
            cell.selected = false
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupDetailCell", forIndexPath: indexPath) as! GroupDetailCell
            
            cell.imgUserHead?.image = UIImage(named: String(self.userIds[indexPath.row - 1]))
            cell.lblUserName.text = self.userNames[indexPath.row - 1]
            cell.txtContent.text = self.replyContents[indexPath.row - 1]
            cell.lblCreateTime.text = self.replyCreateTimes[indexPath.row - 1]
            
            cell.selected = false

            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    }
}