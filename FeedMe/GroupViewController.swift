//
//  GroupViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/29.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import CoreData

class GroupViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 261.5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupListCell", forIndexPath: indexPath) as! GroupListCell
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.itemNum = indexPath.row
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//        
//        self.performSegueWithIdentifier("TalkDetailSegue", sender: itemNum)
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "TalkDetailSegue" {
//            let controller = segue.destinationViewController as! TalkDetailController
//            //controller.itemString = sender as? String
//            controller.itemNum = self.itemNum
//            
//        }
//    }
}
