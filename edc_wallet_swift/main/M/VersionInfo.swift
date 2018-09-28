//
//  VersionInfo.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/12.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class VersionInfo: NSObject {
    var url: String = ""        //下载应用URL
    var title: String  = ""     //title
    var message: String = ""       //提示内容
    var must_update: Bool = false //是否强制更新
    var version: String = ""     //版本
    init(url:String,title:String,message:String,must_update:Bool,version:String) {
        self.url = url
        self.title = title
         self.message = message
         self.must_update = must_update
         self.version = url
        
    }
}
