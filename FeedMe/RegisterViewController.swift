//
//  RegisterViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/16.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    /*
    "result": 1,
    "userId": 3
    */
    
    struct Response : JSONJoy {
        var result: Int?
        var userId: Int?
        init() {
        }
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer
            userId = decoder["userId"].integer
        }
    }
    
    
    @IBOutlet weak var txtUserPhone: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordAgian: UITextField!
    
    @IBAction func getMessage() {
        SMS_SDK.getVerificationCodeBySMSWithPhone(txtUserPhone.text, zone: "86"){
            (error: SMS_SDKError!) in
            if (error == nil) {
                print("Request Succeed! Wait the Message.")
            } else {
                print("Request Failed!")
            }
        }
    }

    @IBAction func register() {
        SMS_SDK.commitVerifyCode(txtCode.text, result: {
            (state: SMS_ResponseState) in
            if (state.rawValue == 1) {
                print("验证成功")
                let request = HTTPTask()
                let params: Dictionary<String,AnyObject> = ["userAccount": self.txtUserPhone.text!, "userPassword": self.txtPassword.text!]
                    request.POST("http://121.42.195.113/feedme/register.action", parameters: params, completionHandler: {(response: HTTPResponse) in
                    if let res: AnyObject = response.responseObject {
                        let json = Response(JSONDecoder(res))
                        print("result: \(json.result!)")
                        if (json.result == 1) {
                            print("注册成功")
                            self.performSegueWithIdentifier("RegisterSegue", sender: self)
                        } else {
                            print("注册失败")
                        }
                    }
                })
                
            } else {
                print("验证失败")
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtUserPhone.resignFirstResponder()
        txtCode.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtPasswordAgian.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}