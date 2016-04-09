//
//  PetMainViewController.swift
//  FeedMe
//
//  Created by Airing on 16/3/26.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit

class PetMainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainColor = UIColor(red: 0.25, green: 0.54, blue: 0.99, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        // 定义所有子页面返回按钮的名称
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
