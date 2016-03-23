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
    var createTimes: Array<String> = []
    var groupImages: Array<String> = []
    var contents: Array<String> = []
    var count: Int = 0
    var pageNumber: Int = 1
    
    struct Group {
        var userId: Int
        var userName: String
        var createTime: String
        var groupImage: String
        var content: String
        
        init(_ decoder: JSONDecoder) {
            userId = decoder["userId"].integer!
            userName = decoder["userName"].string!
            createTime = decoder["discussCreateTime"].string!
            groupImage = decoder["discussImage"].string!
            content = decoder["discussContent"].string!
        }
    }
    
    struct Groups {
        var result: Int!
        var groups = [Group]()
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
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
        
        
        self.tableview.tableFooterView = UIView()
        self.tableview.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDiscuss(pageNumber: Int) {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/discuss_list.action"
        request.POST(discuss_url, parameters: ["page": 1], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Groups(JSONDecoder(res))
                if (json.result == 1) {
                    print(json.groups[1].userName)
                    for(var i = 0; i < 10; i++) {
                        self.userIds.append(json.groups[i].userId)
                        self.userNames.append(json.groups[i].userName)
                        self.createTimes.append(json.groups[i].createTime)
                        self.groupImages.append(json.groups[i].groupImage)
                        self.contents.append(json.groups[i].content)
                        self.count++
                        self.tableview.reloadData()
                    }
                    self.pageNumber++
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
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupTitleCell", forIndexPath: indexPath) as! GroupTitleCell
            
            cell.imgUserHead?.image = UIImage(named: String(self.userIds[indexPath.row]))
            cell.lblUserName.text = self.userNames[indexPath.row]
            cell.txtContent.text = self.contents[indexPath.row]
            cell.imgGroup?.image = UIImage(named: self.groupImages[indexPath.row])
            cell.lblCreateTime.text = self.createTimes[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupDetailCell", forIndexPath: indexPath) as! GroupDetailCell
            
            cell.imgUserHead?.image = UIImage(named: String(self.userIds[indexPath.row]))
            cell.lblUserName.text = self.userNames[indexPath.row]
            cell.txtContent.text = self.contents[indexPath.row]
            cell.lblCreateTime.text = self.createTimes[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
}