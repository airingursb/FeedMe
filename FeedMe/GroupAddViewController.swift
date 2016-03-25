//
//  GroupAddViewController.swift
//  FeedMe
//
//  Created by Airing on 16/3/25.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class GroupAddViewController: UIViewController {
    
    struct Response {
        var result: Int
        var discussId: Int
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
            discussId = decoder["discussId"].integer!
        }
    }
    
    @IBOutlet weak var txtContent: UITextView!
    
    var userId: Int = 0
    var dataUtil: DataUtil = DataUtil()
    
    @IBAction func addNewGroup(sender: UIBarButtonItem) {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/add_discuss.action"
        request.POST(discuss_url, parameters: ["userId": self.userId, "discussTitle": self.txtContent.text, "discussContent": self.txtContent.text], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Response(JSONDecoder(res))
                if (json.result == 1) {
                    print("succeed")
                } else {
                    print("error")
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userId = self.dataUtil.cacheGetInt("userId")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
