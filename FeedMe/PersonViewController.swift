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
import CoreData

class PersonViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    /*
    "result": 1,
    "url": "http://121.42.195.113/feedme/images/face2.png"
    
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
    
    struct Response1: JSONJoy {
        let result: Int?
        let url: String?
        init(_ decoder: JSONDecoder) {
            result = decoder["result"].integer
            url = decoder["url"].string
        }
    }
    
    struct Response2: JSONJoy {
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
    
    var dataUtil: DataUtil = DataUtil()
    
    var imageView: UIImageView!
    var btnPickImage: UIButton!
    var txtUserName: UITextField!
    var imgSexMale: UIImageView!
    var imgSexFemale: UIImageView!
    var btnMale: UIButton!
    var btnFemale: UIButton!
    var btnDate: UIButton!
    var txtUserSign: UITextField!
    var datePicker: UIDatePicker!
    var dateView: UIView!
    
    var userId: Int = 0
    var userName: String = ""
    var userPersonality: String = ""
    var userSex: Int = 0
    var dateStr: String = ""
    var userHead: String = ""
    var imageFileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollEnabled = false
        
        self.userId = self.dataUtil.cacheGetInt("userId")
        
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
            for info: User in fetchedObjects as! [User]{
                print("userName=\(info.userName)")
                self.userName = info.userName!
                self.userPersonality = info.userPersonality!
                self.userSex = info.userSex! as Int
                self.dateStr = info.userBirthday!
                self.userHead = info.userHead!
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
        
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
            let url : NSURL = NSURL(string: self.userHead)!
            let data : NSData = NSData(contentsOfURL:url)!
            let image = UIImage(data: data, scale: 1.0)
            imageView.image = image
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 50
            cell.addSubview(btnPickImage)
            cell.addSubview(imageView)
            return cell
        } else if indexPath.row == 1 {
            cell.lblTitle?.text = "昵称"
            txtUserName = UITextField(frame: CGRectMake(95, 21, 200, 30))
            txtUserName.returnKeyType = UIReturnKeyType.Done
            txtUserName.delegate = self
            txtUserName.borderStyle = UITextBorderStyle.None
            //txtUserName.placeholder = "请输入用户名"
            txtUserName.textAlignment = .Left
            txtUserName.contentVerticalAlignment = .Center
            txtUserName.text = self.userName
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
            btnFemale.addTarget(self, action:Selector("selectFemale"), forControlEvents:UIControlEvents.TouchUpInside)
            
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
            btnDate.addTarget(self, action:Selector("showDate"), forControlEvents:UIControlEvents.TouchUpInside)
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
            txtUserSign.text = self.userPersonality
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
            fileName = "head_\(self.userId).jpg"
        } else {
            data = UIImagePNGRepresentation(image)!;
            mimeType = "image/png"
            fileName = "head_\(self.userId).png"
        }
        
        do {
            let request = HTTPTask()
            
            request.POST("http://121.42.195.113/feedme/upload_head.action", parameters:  ["upload": HTTPUpload(data: data, fileName: fileName, mimeType: mimeType)], completionHandler: {(response: HTTPResponse) in
                if let res: AnyObject = response.responseObject {
                    let json = Response1(JSONDecoder(res))
                    if (json.result == 1) {
                        print(json.url!)
                        self.imageFileName = json.url!
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
        self.userSex = 1
    }
    
    func selectFemale() {
        btnFemale.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btnMale.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.userSex = 2
    }
    
    func showDate() {
        dateView = UIView(frame: CGRectMake(0, 0, 375, 300))
        dateView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(dateView)
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, 375, 180))
        datePicker.datePickerMode = UIDatePickerMode.Date
        self.dateView.addSubview(datePicker)
        let btnDateReturn:UIButton = UIButton(frame: CGRectMake(167.5, 200, 40, 30))
        btnDateReturn.setTitle("确定", forState: .Normal)
        btnDateReturn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btnDateReturn.addTarget(self, action:Selector("dateReturn"), forControlEvents:UIControlEvents.TouchUpInside)
        self.dateView.addSubview(btnDateReturn)
        //self.performSegueWithIdentifier("ShowDateSegue", sender: dateStr)
    }
    
    func dateReturn() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateStr = dateFormatter.stringFromDate(datePicker.date)
        self.btnDate.setTitle(dateStr, forState: .Normal)
        self.dateView.removeFromSuperview()
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
    
    @IBAction func updateInfo(sender: UIBarButtonItem) {
        
        let request = HTTPTask()
        let params: Dictionary<String,AnyObject> = [
            "userId": self.userId,
            "userName": self.txtUserName.text!,
            "userSex": self.userSex,
            "userHead": self.imageFileName,
            "userBirthday": self.dateStr,
            "userPersonality": self.txtUserSign.text!
        ]
        
        request.POST("http://121.42.195.113/feedme/update_user_info.action", parameters: params, completionHandler: {(response: HTTPResponse) in
            if let res: AnyObject = response.responseObject {
                let json = Response2(JSONDecoder(res))
                if (json.result == 1) {
                    self.userId = json.userId!
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
                        for info: User in fetchedObjects as! [User]{
                            print("userName=\(info.userName)")
                            info.userName = json.userName
                            info.userPersonality = json.userPersonality
                            info.userSex = json.userSex
                            info.userBirthday = json.userBirthday
                            info.userHead = json.userHead
                            
                            try context.save()
                        }
                    }
                    catch {
                        fatalError("不能保存：\(error)")
                    }
                    // self.performSegueWithIdentifier("SettingToListSegue", sender: nil)

                } else {
                    let alertController = UIAlertController(title: "FeedMe",
                        message: "Networking Failed!", preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        })
    }
}
