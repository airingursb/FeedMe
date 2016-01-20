//
//  MainWordViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/20.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit

class MainWordViewController: UIViewController {
    
    @IBOutlet weak var lblBookName: UILabel!
    @IBOutlet weak var lblUtilName: UILabel!
    
    @IBOutlet weak var lblDays: UILabel!
    
    @IBOutlet weak var lblNewWord: UILabel!
    @IBOutlet weak var lblLearnedWord: UILabel!
    @IBOutlet weak var lblMasterWord: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainColor = UIColor(red: 0.25, green: 0.54, blue: 0.99, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        // 定义所有子页面返回按钮的名称
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}