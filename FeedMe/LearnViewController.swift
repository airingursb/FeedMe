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
    
    struct ResponseNext {
        var result: Int
        var wordId: Int
        var wordSpell: String
        var wordSpeech: String
        var wordMean: String
        var wordPhoneticSymbol: String
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
            wordId = decoder["wordId"].integer!
            wordSpell = decoder["wordSpell"].string!
            wordSpeech = decoder["wordSpeech"].string!
            wordMean = decoder["wordMean"].string!
            wordPhoneticSymbol = decoder["wordPhoneticSymbol"].string!
        }
    }
    
    struct ResponseMiss {
        var result: Int!
        var wordExample: String!
        var wordMeanOfExample: String!
        
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer!
            wordExample = decoder["wordExample1"].string!
            wordMeanOfExample = decoder["wordMeanOfExample1"].string!
        }
    }
    
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblSpell: UILabel!
    @IBOutlet weak var lblMean: UILabel!
    
    var wordId: Int = 0
    var userId: Int = 0
    var wordSpell: String = ""
    var wordExample: String = ""
    var wordMeanOfExample: String = ""
    var wordMean: String = ""
    var count: Int = 0
    var dataUtil: DataUtil = DataUtil()
    
    @IBAction func delete() {
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/master_word.action"
        request.POST(discuss_url, parameters: ["userId": self.userId, "wordId": self.wordId], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = ResponseMaster(JSONDecoder(res))
                if (json.result == 1) {
                    print(json)
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
            if let _: AnyObject = response.responseObject {
            }
        })
        
        getNextWord()
    }
    
    @IBAction func miss() {
        if self.count == 0 {
            let request = HTTPTask()
            let config = ConfigUtil()
            let discuss_url = config.host! + "/no_knowing_word.action"
            request.POST(discuss_url, parameters: ["userId": self.userId, "wordId": self.wordId], completionHandler: {(response: HTTPResponse) in
                if let res: AnyObject = response.responseObject {
                    let json = ResponseMiss(JSONDecoder(res))
                    if (json.result == 1) {
                        print(json)
                        self.wordExample = json.wordExample
                        self.wordMeanOfExample = json.wordMeanOfExample
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.lblMean.text = self.wordMean
                        })
                    } else {
                        print("error")
                    }
                }
            })
        } else if self.count == 1 {
            self.lblMean.text = self.wordExample
        } else if self.count == 2{
            self.lblMean.text = self.wordMeanOfExample
        } else {
            self.lblMean.text = self.wordMean
        }
        self.count++
    }
    
    func getNextWord() {
        self.count = 0
        self.lblMean.text = ""
        let request = HTTPTask()
        let config = ConfigUtil()
        let discuss_url = config.host! + "/next_word.action"
        request.POST(discuss_url, parameters: ["userId": self.userId], completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = ResponseNext(JSONDecoder(res))
                if (json.result == 1) {
                    print(json)
                    self.wordId = json.wordId
                    self.wordMean = json.wordMean
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.lblWord.text = json.wordSpell
                        self.lblSpell.text = json.wordPhoneticSymbol
                    })
                } else {
                    print("error")
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNextWord()

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