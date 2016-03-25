//
//  ConfigUtil.swift
//  FeedMe
//
//  Created by Airing on 16/3/1.
//  Copyright © 2016年 Airing. All rights reserved.
//

import Foundation

class ConfigUtil {
    var _host: String? = "http://192.168.173.1:8080/feedme"
    
    var host: String? {
        get {
            return self._host
        }
        set {
            print("")
        }
    }
}