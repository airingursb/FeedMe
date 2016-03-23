//
//  GroupViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/29.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import CoreData
import JSONJoy
import SwiftHTTP
import XWSwiftRefresh

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var userIds: Array<Int> = []
    var userNames: Array<String> = []
    var createTimes: Array<String> = []
    var replyNumbers: Array<Int> = []
    var groupImages: Array<String> = []
    var contents: Array<String> = []
    var count: Int = 0
    var pageNumber: Int = 1
    
    struct Group {
        var userId: Int
        var userName: String
        var createTime: String
        var replyNumber: Int
        var groupImage: String
        var content: String
        
        init(_ decoder: JSONDecoder) {
            userId = decoder["userId"].integer!
            userName = decoder["userName"].string!
            createTime = decoder["discussCreateTime"].string!
            replyNumber = decoder["discussReplyNum"].integer!
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

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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
                        self.replyNumbers.append(json.groups[i].replyNumber)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 261.5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupListCell", forIndexPath: indexPath) as! GroupListCell
        
            cell.imgUserHead?.image = UIImage(named: String(self.userIds[indexPath.row]))
            cell.lblUserName.text = self.userNames[indexPath.row]
            cell.lblContent.text = self.contents[indexPath.row]
            cell.imgGroup?.image = UIImage(named: self.groupImages[indexPath.row])
            cell.lblCreateDate.text = self.createTimes[indexPath.row]
            cell.lblRetryNumber.text = String(self.replyNumbers[indexPath.row])
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.itemNum = indexPath.row
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//        
//        self.performSegueWithIdentifier("TalkDetailSegue", sender: itemNum)
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "TalkDetailSegue" {
//            let controller = segue.destinationViewController as! TalkDetailController
//            //controller.itemString = sender as? String
//            controller.itemNum = self.itemNum
//            
//        }
//    }
}
