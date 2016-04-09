//
//  GroupReplyViewController.swift
//  FeedMe
//
//  Created by Airing on 16/3/25.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class GroupReplyViewController: UIViewController {
    
    struct Response {
        var result: Int!
        var replyId: Int!
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
            replyId = decoder["replyId"].integer!
        }
    }
    
    
    @IBOutlet weak var txtContent: UITextView!
    
    var userId: Int = 0
    var discussId: Int = 0
    var dataUtil: DataUtil = DataUtil()
    
    
    @IBAction func addReply(sender: UIBarButtonItem) {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/add_reply.action"
        request.POST(discuss_url, parameters: ["userId": self.userId, "discussId": self.discussId, "replyContent": self.txtContent.text], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Response(JSONDecoder(res))
                print(json)
                if (json.result == 1) {
                    print("succeed")
//                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                        self.performSegueWithIdentifier("ReplySegue", sender: self.userId)
//                    })
//                    let vc = GroupDetailViewController()
//                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    print("error")
                }
            }
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userId = self.dataUtil.cacheGetInt("userId")
        self.discussId = self.dataUtil.cacheGetInt("discussId")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}