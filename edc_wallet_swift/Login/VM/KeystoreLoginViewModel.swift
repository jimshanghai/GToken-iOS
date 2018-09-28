//
//  KeystoreLoginViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/3.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD
class KeystoreLoginViewModel: NSObject {
    weak var target:KLoginPrivateViewController!

    func keyStoreLogin(dic:NSDictionary){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_keystorelogin, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            SVProgressHUD.dismiss()
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                //进入主页
                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["private_address"], forKey: "private_address_gongga")//钱包地址
                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["token"], forKey: "access_token")
                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["name"], forKey: "name")
                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["numbers"], forKey: "numbers")
                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["avatar"], forKey: "avatar")
                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["type"], forKey: "keystoreUser")//是不是keystore用户  1不是  2
                if((result.object(forKey: "data") as!NSDictionary)["email"] != nil && !((result.object(forKey: "data") as!NSDictionary)["email"]  is  NSNull)){
                    UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["email"], forKey: "email")
                }
                if((result.object(forKey: "data") as!NSDictionary)["mobile"] != nil && !((result.object(forKey: "data") as!NSDictionary)["email"]  is  NSNull)){
                    UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["mobile"], forKey: "mobile")
                }
//                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["email"], forKey: "email")
                UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["keystore"], forKey: "keystorejson")
                let main = MainTabbarViewController.CustomTabBar();
                UIApplication.shared.delegate?.window??.backgroundColor = UIColor.white
                UIApplication.shared.delegate?.window??.rootViewController = main
            }else{
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String))
            }
        }) { (error) in
              SVProgressHUD.dismiss()
             self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
        }
        
    }
}
