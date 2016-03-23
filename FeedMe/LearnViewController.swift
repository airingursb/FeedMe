//
//  LearnViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/20.
//  Copyright © 2016年 Airing. All rights reserved.
//


import UIKit

class LearnViewController: UIViewController {
    
    
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblSpell: UILabel!
    @IBOutlet weak var lblMean: UILabel!
    
    @IBAction func delete() {
        
    }
    
    
    @IBAction func pass() {
        
    }
    
    @IBAction func miss() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}