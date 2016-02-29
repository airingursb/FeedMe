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
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    /*
    "result": 1,
    "userId": 3,
    "userAccount": "18154099269",
    "userName": "Airing",
    "userHead": "http://121.42.195.113/feedme/images/head_2.png",
    "userCreateTime": "2016/02/03",
    "userPoint": 0,
    "userSex": 1,
    "userBirthday": "1995/06/30",
    "userPersonality": "Orion"
    */
    
    struct Response : JSONJoy {
        var result: Int?
        var userId: Int?
        var userAccount: String?
        var userName: String?
        var userHead: String?
        var userCreateTime: String?
        var userPoint: Int?
        var userSex: Int?
        var userBirthday: String?
        var userPersonality: String?
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
            userSex = decoder["userSex"].integer
            userBirthday = decoder["userBirthday"].string
            userPersonality = decoder["userPersonality"].string
        }
    }
    
    var userId:Int = 0
    var verifyFlag:Int = 0
    
    @IBOutlet weak var txtUserAccount: UITextField!
    @IBOutlet weak var txtUserPassword: UITextField!
    @IBOutlet weak var imgLogo: UIImageView!
    
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
    
    @IBAction func loginByQQ() {
        ShareSDK.authorize(SSDKPlatformType.TypeQQ, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
            case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("操作取消")
                
            default:
                break
            }
        })
    }
    
    @IBAction func loginByWechat() {
    }
    
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
        //let params2: Dictionary<String,AnyObject> = ["username": "airing", "password": "123"]
        
        request.POST("http://192.168.20.229:8080/feedme/login.action", parameters: params, completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Response(JSONDecoder(res))
                if (json.result == 1) {
                    self.userId = json.userId!
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.performSegueWithIdentifier("LoginSegue", sender: self.userId)
                    })
                    
                    var userIsExisted = false
                    
                    let app = UIApplication.sharedApplication().delegate as! AppDelegate
                    let context = app.managedObjectContext
                    let fetchRequest:NSFetchRequest = NSFetchRequest()
                    fetchRequest.fetchLimit = 10
                    fetchRequest.fetchOffset = 0
                    
                    let entity:NSEntityDescription? = NSEntityDescription.entityForName("User",
                        inManagedObjectContext: context)
                    fetchRequest.entity = entity
                    
                    let predicate = NSPredicate(format: "userId= \(self.userId)" , "")
                    fetchRequest.predicate = predicate
                    
                    do {
                        let fetchedObjects:[AnyObject]? = try context.executeFetchRequest(fetchRequest)
                        for info:User in fetchedObjects as! [User]{
                            print("userName=\(info.userName)")
                            if info.userName != nil {
                                userIsExisted = true
                                info.userAccount = json.userAccount
                                info.userName = json.userName
                                info.userHead = json.userHead
                                info.userCreateTime = json.userCreateTime
                                info.userPoint = json.userPoint
                                info.userSex = json.userSex
                                info.userBirthday = json.userBirthday
                                info.userPersonality = json.userPersonality
                                
                                try context.save()
                            }
                        }
                    }
                    catch {
                        fatalError("不能保存：\(error)")
                    }
                    
                    print("userIsExisted: \(userIsExisted)")
                    
                    if userIsExisted == false {
        
                        let user = NSEntityDescription.insertNewObjectForEntityForName("User",
                        inManagedObjectContext: context) as! User
                    
                        user.userId = json.userId
                        user.userAccount = json.userAccount
                        user.userName = json.userName
                        user.userHead = json.userHead
                        user.userCreateTime = json.userCreateTime
                        user.userPoint = json.userPoint
                        user.userSex = json.userSex
                        user.userBirthday = json.userBirthday
                        user.userPersonality = json.userPersonality
                        
                        do {
                            try context.save()
                            print("保存成功！")
                        } catch {
                            fatalError("不能保存：\(error)")
                        }
                    }
                    
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

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtUserAccount.resignFirstResponder()
        txtUserPassword.resignFirstResponder()
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
