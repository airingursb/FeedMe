//
//  DatePickerViewController.swift
//  FeedMe
//
//  Created by Airing on 16/2/2.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var dateStr: String = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dateStr)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func click() {
        let date = datePicker.date
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd"
        dateStr = dateformatter.stringFromDate(date)
        print(dateStr)
        self.performSegueWithIdentifier("ReturnSetSegue", sender: dateStr)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReturnSetSegue" {
            let controller = segue.destinationViewController as! PersonViewController
            
            controller.dateStr = self.dateStr
        }
    }
}
