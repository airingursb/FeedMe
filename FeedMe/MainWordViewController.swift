//
//  MainWordViewController.swift
//  FeedMe
//
//  Created by Airing on 16/1/20.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import CoreData

class MainWordViewController: UIViewController {
    
    @IBOutlet weak var lblBookName: UILabel!
    @IBOutlet weak var lblUtilName: UILabel!
    
    @IBOutlet weak var lblDays: UILabel!
    
    @IBOutlet weak var lblNewWord: UILabel!
    @IBOutlet weak var lblLearnedWord: UILabel!
    @IBOutlet weak var lblMasterWord: UILabel!
    
    var userId:Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let mainColor = UIColor(red: 0.25, green: 0.54, blue: 0.99, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        // 定义所有子页面返回按钮的名称
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        
        //获取管理的数据上下文 对象
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        //声明一个实体结构
        let entity:NSEntityDescription? = NSEntityDescription.entityForName("User",
            inManagedObjectContext: context)
        //设置数据请求的实体结构
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate(format: "age= '12' ", "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects:[AnyObject]? = try context.executeFetchRequest(fetchRequest)
            
            //遍历查询的结果
            for info:User in fetchedObjects as! [User]{
                print("name=\(info.name)")
                print("age=\(info.age)")
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}