//
//  LearnViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/20.
//  Copyright © 2016年 Airing. All rights reserved.
//


import UIKit
import SwiftHTTP
import JSONJoy
import CoreData

class LearnViewController: UIViewController {
    
    struct ResponseMaster {
        var result: Int
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
        }
    }
    
    struct ResponsePass {
        var result: Int
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
        }
    }
    
    struct ResponseMiss {
        var result: Int
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
        }
    }
    
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblSpell: UILabel!
    @IBOutlet weak var lblMean: UILabel!
    
    var wordId: Int = 0
    var userId: Int = 0
    var dataUtil: DataUtil = DataUtil()
    
    @IBAction func delete() {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/master_word.action"
        request.POST(discuss_url, parameters: ["userId": self.userId, "wordId": self.wordId], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = ResponseMaster(JSONDecoder(res))
                if (json.result == 1) {
                    print("succeed")
                } else {
                    print("error")
                }
            }
        })

    }
    
    
    @IBAction func pass() {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/knowing_word.action"
        request.POST(discuss_url, parameters: ["userId": self.userId, "wordId": self.wordId], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = ResponsePass(JSONDecoder(res))
                if (json.result == 1) {
                    print("succeed")
                } else {
                    print("error")
                }
            }
        })
    }
    
    @IBAction func miss() {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/no_knowing_word.action"
        request.POST(discuss_url, parameters: ["userId": self.userId, "wordId": self.wordId], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = ResponseMiss(JSONDecoder(res))
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
        
        let mainColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        self.userId = self.dataUtil.cacheGetInt("userId")

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}