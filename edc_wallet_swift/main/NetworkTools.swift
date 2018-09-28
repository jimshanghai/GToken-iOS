//
//  NetworkTools.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/16.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
   
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("application/json")
        tools.responseSerializer.acceptableContentTypes?.insert("text/json")
        tools.responseSerializer.acceptableContentTypes?.insert("text/javascript")
        
        tools.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        return tools
    }()
    func request(methodType: RequestType,
                 urlString: String,
                 params: [String: AnyObject]?,
                 success:@escaping (_ json: AnyObject?) -> Void,
                 fail: @escaping (_ error: Error?) -> Void) {
        
        /// 定义成功回调闭包
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            
            NSLog("ok")
            success(json as AnyObject?)
        }
        
        /// 定义失败回调闭包
        let failure = {(task: URLSessionDataTask?, error: Error)->() in
    
            NSLog("fail%d",error.localizedDescription)
            
            fail(error);
        }
        
        if methodType == .GET { // GET
            get(urlString, parameters: params, progress: nil, success: success, failure: failure)
        } else { // POST
            post(urlString, parameters: params, progress: nil, success: success, failure: failure)
        }
    }
}
