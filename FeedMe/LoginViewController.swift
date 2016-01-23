//
//  LoginViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/16.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    /*
    "result": 1,
    "userId": 2,
    "userAccount": "18154099269",
    "userName": "18819477586",
    "userHead": "http://121.42.195.113/feedme/image/default.jpg",
    "userCreateTime": "Jan 21, 2016 4:08:21 PM",
    "userPoint": 0
    */
    
    struct User : JSONJoy {
        var result: Int?
        var userId: Int?
        var userAccount: String?
        var userName: String?
        var userHead: String?
        var userCreateTime: String?
        var userPoint: Int?
        init() {
        }
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer
            userId = decoder["userId"].integer
            userAccount = decoder["userAccount"].string
            userName = decoder["userName"].string
            userHead = decoder["userHead"].string
            userCreateTime = decoder["userCreateTime"].string
            userPoint = decoder["userPoint"].integer
        }
    }
    
    var userId:Int = 0
    var verifyFlag:Int = 0
    
    @IBOutlet weak var txtUserAccount: UITextField!
    @IBOutlet weak var txtUserPassword: UITextField!
    
    @IBAction func login() {
        
        verifyFlag = 0
        verify()
        
        if (verifyFlag == 0) {
            
            let alertController = UIAlertController(title: "FeedMe",
                message: "Please Input Your Account and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            sendAndReceive()
        }
        
    }
    
//    @IBAction func loginByQQ() {
//        ShareSDK.authorize(SSDKPlatformType.TypeQQ, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
//            
//            switch state{
//                
//            case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
//            case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
//            case SSDKResponseState.Cancel:  print("操作取消")
//                
//            default:
//                break
//            }
//        })
//    }
//    
//    @IBAction func loginByWechat() {
//        
//    }
    
    func verify(){
        if(self.txtUserAccount.text == "" || self.txtUserPassword.text == "") {
            verifyFlag = 0
        } else {
            verifyFlag = 1
        }
    
    }
    
    func sendAndReceive() {
        let request = HTTPTask()
        let params: Dictionary<String,AnyObject> = ["userAccount": txtUserAccount.text!, "userPassword": txtUserPassword.text!]
        request.POST("http://121.42.195.113/feedme/login.action", parameters: params, completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let user = User(JSONDecoder(res))
                print("result:\(user.result!)\nuserId:\(user.userId!)\nuserAccount:\(user.userAccount!)\nuserName:\(user.userName!)\nuserHead:\(user.userHead!)\nuserCreateTime:\(user.userCreateTime!)\nuserPoint:\(user.userPoint!)")
                if (user.result! == 1) {
                    self.userId = user.userId!
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.performSegueWithIdentifier("LoginSegue", sender: self.userId)
                    })
                    
                } else {
                    let alertController = UIAlertController(title: "FeedMe",
                        message: "Please Check Your Message.", preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if verifyFlag == 1 {
            if segue.identifier == "LoginSegue" {
                
                let tabCtrl = segue.destinationViewController as! UITabBarController
                let nav = tabCtrl.viewControllers![0] as! UINavigationController
                let controller = nav.topViewController as! MainWordViewController
                controller.userId = self.userId;
            }
        }
    }
    
}
