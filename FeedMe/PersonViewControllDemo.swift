//
//  PersonViewControllDemo.swift
//  FeedMe
//
//  Created by Airing on 16/1/31.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import JSONJoy
import SwiftHTTP

class PersonViewControllDemo: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfoCell", forIndexPath: indexPath) as! PersonInfoCell
        
        if indexPath.row == 0 {
            cell.lblTitle?.text = "头像"
            imageView = UIImageView(frame: CGRectMake(264, 10, 120, 120))
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            cell.addSubview(imageView)
        } else if indexPath.row == 1 {
            cell.lblTitle?.text = "昵称"
        } else if indexPath.row == 2 {
            cell.lblTitle?.text = "性别"
        } else if indexPath.row == 3 {
            cell.lblTitle?.text = "生日"
        } else {
            cell.lblTitle?.text = "签名"
        }
        return cell
        
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
}
