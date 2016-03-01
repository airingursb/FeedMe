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

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Group {
        var userId: Int
        var userName: String
        var createTime: String
        var replyNumber: Int
        var groupImage: String
        var content: String
        
        init(_ decoder: JSONDecoder) throws {
            userId = decoder["userId"].integer!
            userName = decoder["userName"].string!
            createTime = decoder["discussCreateTime"].string!
            replyNumber = decoder["discussReplyNum"].integer!
            groupImage = decoder["discussImage"].string!
            content = decoder["discussContent"].string!
        }
    }
    
    struct Groups {
        var result: Int
        var groups = [Group]()
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
            //guard let addrs = decoder["groups"].array else {throw JSONError.WrongType}
            let addrs = decoder["dataList"].array
            for addrDecoder in addrs! {
                try? groups.append(Group(addrDecoder))
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
        
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/discuss_list.action"
        request.POST(discuss_url, parameters: ["page": 1], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Groups(JSONDecoder(res))
                if (json.result == 1) {
                    print(json.groups[1].userName)
                } else {
                    print("error")
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 261.5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupListCell", forIndexPath: indexPath) as! GroupListCell
        
//        cell.imgUserHead?.image = UIImage(named: userHeads[indexPath.row])
//        cell.lblUserName.text = userNames[indexPath.row]
//        cell.lblContent.text = contents[indexPath.row]
//        cell.imgGroup?.image = UIImage(named: contentsOfImage[indexPath.row])
//        cell.lblCreateDate.text = publicDate[indexPath.row]
//        cell.lblRetryNumber.text = retryNumber[indexPath.row]
        //cell.btnRetry?.image = UIImage(named: "icon-comment")
        
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
