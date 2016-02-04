//
//  DataUtil.swift
//  FeedMe
//
//  Created by Airing on 16/2/4.
//  Copyright © 2016年 Airing. All rights reserved.
//

import Foundation

class DataUtil {
    
    func cacheSetString(key: String,value: String){
        let userInfo = NSUserDefaults()
        userInfo.setValue(value, forKey: key)
    }
    
    func cacheGetString(key: String) -> String{
        let userInfo = NSUserDefaults()
        let tmpSign = userInfo.stringForKey(key)
        return tmpSign!
    }
    
    
    func cacheSetInt(key: String,value: Int){
        let userInfo = NSUserDefaults()
        userInfo.setValue(value, forKey: key)
    }
    
    func cacheGetInt(key: String) -> Int{
        let userInfo = NSUserDefaults()
        let tmpSign = userInfo.stringForKey(key)
        return Int(tmpSign!)!
    }
    
}