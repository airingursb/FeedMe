//
//  MenuViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/22.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var imgUserHead: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = ConfigUtil()
        let image_url = config.host! + "/images/1.jpg"
        let url: NSURL = NSURL(string: image_url)!
        if let data: NSData = NSData(contentsOfURL: url){
            let image = UIImage(data: data, scale: 1.0)
            imgUserHead.image = image
        }
        imgUserHead.layer.masksToBounds = true
        imgUserHead.layer.cornerRadius = 50
        lblUserName.text = "王小明"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}