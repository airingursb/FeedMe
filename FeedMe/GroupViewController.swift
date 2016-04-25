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
    var discussIds: Array<Int> = []
    var createTimes: Array<String> = []
    var replyNumbers: Array<Int> = []
    var groupImages: Array<String> = []
    var contents: Array<String> = []
    var userHeads: Array<String> = []
    var count: Int = 0
    var pageNumber: Int = 1
    
    var discussId: Int = 0
    var dataUtil: DataUtil = DataUtil()

    struct Group {
        var userId: Int
        var userName: String
        var discussId: Int
        var createTime: String
        var replyNumber: Int
        var groupImage: String
        var content: String
        var userHead: String
        
        init(_ decoder: JSONDecoder) {
            userId = decoder["userId"].integer!
            userName = decoder["userName"].string!
            discussId = decoder["discussId"].integer!
            createTime = decoder["discussCreateTime"].string!
            replyNumber = decoder["discussReplyNum"].integer!
            groupImage = decoder["discussImage"].string!
            content = decoder["discussContent"].string!
            userHead = decoder["userHead"].string!
        }
    }
    
    struct Groups {
        var result: Int!
        var discussNum: Int!
        var groups = [Group]()
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
            discussNum = decoder["discussNum"].integer!
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
        
        let mainColor = UIColor(red: 0.25, green: 0.54, blue: 0.99, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        // 定义所有子页面返回按钮的名称
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
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
        request.POST(discuss_url, parameters: ["page": self.pageNumber], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Groups(JSONDecoder(res))
                if (json.result == 1) {
                    print(json.groups[1].userName)
                    if json.discussNum != 0 {
                        for(var i = 0; i < json.discussNum; i++) {
                            self.userIds.append(json.groups[i].userId)
                            self.userNames.append(json.groups[i].userName)
                            self.discussIds.append(json.groups[i].discussId)
                            self.createTimes.append(json.groups[i].createTime)
                            self.replyNumbers.append(json.groups[i].replyNumber)
                            self.groupImages.append(json.groups[i].groupImage)
                            self.contents.append(json.groups[i].content)
                            self.userHeads.append(json.groups[i].userHead)
                            self.count++
                            self.tableview.reloadData()
                        }
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 261.5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupListCell", forIndexPath: indexPath) as! GroupListCell
        
        cell.imgUserHead?.image = UIImage(named: String(self.userIds[indexPath.row]))
        cell.lblUserName.text = self.userNames[indexPath.row]
        cell.txtContent.text = self.contents[indexPath.row]
        cell.lblCreateDate.text = self.createTimes[indexPath.row]
        cell.lblRetryNumber.text = String(self.replyNumbers[indexPath.row])
        let user_url: NSURL = NSURL(string: self.userHeads[indexPath.row])!
        if let data: NSData = NSData(contentsOfURL: user_url){
            let image = UIImage(data: data, scale: 1.0)
            cell.imgUserHead.image = image
        }
        let group_url: NSURL = NSURL(string: self.groupImages[indexPath.row])!
        if let data: NSData = NSData(contentsOfURL: group_url){
            let image = UIImage(data: data, scale: 1.0)
            cell.imgGroup.image = image
        }
        
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.discussId = self.discussIds[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        self.performSegueWithIdentifier("GroupDetailSegue", sender: discussId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GroupDetailSegue" {
            let controller = segue.destinationViewController as! GroupDetailViewController
            //controller.itemString = sender as? String
            controller.discussId = self.discussId
            print("discussId:\(self.discussId)")
            self.dataUtil.cacheSetInt("discussId", value: self.discussId)
        }
    }
}
