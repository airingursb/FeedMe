//
//  PersonViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/31.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import JSONJoy
import SwiftHTTP

class PersonViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    /*
    "result": 1,
    "url": "http://121.42.195.113/feedme/images/face2.png"
    */
    struct Response: JSONJoy {
        let result: Int?
        let url: String?
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer
            url = decoder["url"].string
        }
    }
    
    var imageView: UIImageView!
    var btnPickImage: UIButton!
    var txtUserName: UITextField!
    var imgSexMale: UIImageView!
    var imgSexFemale: UIImageView!
    var btnMale: UIButton!
    var btnFemale: UIButton!
    var btnDate: UIButton!
    var txtUserSign: UITextField!
    
    var userName: String = ""
    var userSign: String = ""
    var sex: Int = 0
    var dateStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140
        } else if indexPath.row == 4{
            return 210
        } else {
            return 70
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfoCell", forIndexPath: indexPath) as! PersonInfoCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row == 0 {
            cell.lblTitle?.text = "头像"
            imageView = UIImageView(frame: CGRectMake(264, 20, 100, 100))
            btnPickImage = UIButton(frame: CGRectMake(84, 55, 90, 30))
            btnPickImage.setTitle("重新设置", forState: UIControlState.Normal)
            btnPickImage.titleLabel?.textAlignment = .Left
            btnPickImage.titleLabel?.font = UIFont(name: "System", size: 11)
            btnPickImage.setTitleColor(UIColor.grayColor(), forState: .Normal)
            btnPickImage.addTarget(self,action:Selector("pickImage"),forControlEvents:UIControlEvents.TouchUpInside)
            cell.addSubview(btnPickImage)
            cell.addSubview(imageView)
            return cell
        } else if indexPath.row == 1 {
            cell.lblTitle?.text = "昵称"
            txtUserName = UITextField(frame: CGRectMake(95, 21, 200, 30))
            txtUserName.returnKeyType = UIReturnKeyType.Done
            txtUserName.delegate = self
            txtUserName.borderStyle = UITextBorderStyle.None
            txtUserName.placeholder = "请输入用户名"
            txtUserName.textAlignment = .Left
            txtUserName.contentVerticalAlignment = .Center
            cell.addSubview(txtUserName)
            return cell
        } else if indexPath.row == 2 {
            cell.lblTitle?.text = "性别"
            imgSexMale = UIImageView(image:UIImage(named:"male"))
            imgSexMale.frame = CGRectMake(95, 25, 16, 16)
            imgSexFemale = UIImageView(image:UIImage(named:"female"))
            imgSexFemale.frame = CGRectMake(195, 25, 12.5, 17)
            
            btnMale = UIButton(frame: CGRectMake(125, 25, 20, 20))
            btnMale.setTitle("男", forState: UIControlState.Normal)
            btnMale.setTitleColor(UIColor.grayColor(), forState: .Normal)
            btnMale.addTarget(self,action:Selector("selectMale"),forControlEvents:UIControlEvents.TouchUpInside)
            
            btnFemale = UIButton(frame: CGRectMake(225, 25, 20, 20))
            btnFemale.setTitle("女", forState: UIControlState.Normal)
            btnFemale.setTitleColor(UIColor.grayColor(), forState: .Normal)
            btnFemale.addTarget(self,action:Selector("selectFemale"),forControlEvents:UIControlEvents.TouchUpInside)
            
            cell.addSubview(btnMale)
            cell.addSubview(btnFemale)
            cell.addSubview(imgSexMale)
            cell.addSubview(imgSexFemale)
            return cell
        } else if indexPath.row == 3 {
            cell.lblTitle?.text = "生日"
            btnDate = UIButton(frame: CGRectMake(85, 25, 120, 20))
            btnDate.setTitle(dateStr, forState: .Normal)
            btnDate.setTitleColor(UIColor.grayColor(), forState: .Normal)
            btnDate.addTarget(self,action:Selector("showDate"),forControlEvents:UIControlEvents.TouchUpInside)
            cell.addSubview(btnDate)
            return cell
        } else {
            cell.lblTitle?.text = "签名"
            txtUserSign = UITextField(frame: CGRectMake(95, 21, 240, 160))
            txtUserSign.returnKeyType = UIReturnKeyType.Done
            txtUserSign.delegate = self
            txtUserSign.borderStyle = UITextBorderStyle.None
            txtUserSign.textAlignment = .Left
            txtUserSign.contentVerticalAlignment = .Top
            cell.addSubview(txtUserSign)
            return cell
        }
    }
    
    @IBAction func pickImage() {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            print("read album error")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        
        var data: NSData
        var mimeType: String
        var fileName: String
        
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1)!;
            mimeType = "image/jpeg"
            fileName = "head_" + ".jpg"
        } else {
            data = UIImagePNGRepresentation(image)!;
            mimeType = "image/png"
            fileName = "head_" + ".png"
        }
        
        do {
            let request = HTTPTask()
            
            request.POST("http://121.42.195.113/feedme/upload_head.action", parameters:  ["upload": HTTPUpload(data: data, fileName: fileName, mimeType: mimeType)], completionHandler: {(response: HTTPResponse) in
                if let res: AnyObject = response.responseObject {
                    let json = Response(JSONDecoder(res))
                    if (json.result == 1) {
                        print(json.url!)
                    } else {
                        print("error")
                    }
                }
            })
        }
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectMale() {
        btnMale.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btnFemale.setTitleColor(UIColor.grayColor(), forState: .Normal)
        sex = 1
    }
    
    func selectFemale() {
        btnFemale.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btnMale.setTitleColor(UIColor.grayColor(), forState: .Normal)
        sex = 0
    }
    
    func showDate() {
        self.performSegueWithIdentifier("ShowDateSegue", sender: dateStr)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtUserName.resignFirstResponder()
        txtUserSign.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDateSegue" {
            let controller = segue.destinationViewController as! DatePickerViewController
            controller.dateStr = self.dateStr
        }
    }
}
