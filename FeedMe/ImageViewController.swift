//
//  ImageViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/27.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imgUserHead: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgUserHead.image = image
        
        do {
            let request = HTTPTask()
            
            request.POST("http://121.42.195.113/feedme/upload_head.action", parameters:  ["upload": HTTPUpload(data: UIImageJPEGRepresentation(image, 1)!, fileName: "sb.jpg", mimeType: "image/jpeg")], completionHandler: {(response: HTTPResponse) in
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
