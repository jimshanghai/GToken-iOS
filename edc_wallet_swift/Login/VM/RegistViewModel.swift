//
//  RegistViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/20.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistViewModel: NSObject {
    weak var target:RegistViewController!
    //发送验证码
    func sendsms(dic:NSDictionary){
            SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_sms, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            SVProgressHUD.dismiss()
            // 开启倒计时
            self.target.sendSMS.count = 60
            self.target.sendSMS.numberColor = UIColor.white
            self.target.sendSMS.startCountDown()
        }) { (error) in
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
        }
        
    }
    //发送验证码
    func sendemailcode(dic:NSDictionary){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_email, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            SVProgressHUD.dismiss()
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as! String  == "200" ){
                // 开启倒计时
                self.target.sendSMS.count = 60
                self.target.sendSMS.numberColor = UIColor.white
                self.target.sendSMS.startCountDown()
            }else{
                 self.target.alertWithClick(msg: NSLocalizedString(result.object(forKey: "msg")as! String, comment: "") )
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
    //注册
    func regitser(dic:NSDictionary){
         SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_regist, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                SVProgressHUD.dismiss()
                if(self.target.isBindUser){
                    //主页面
                    
                    
                }else{
                      self.target.alertWithClick(msg: NSLocalizedString("注册成功", comment: ""))
                      self.target.navigationController?.popViewController(animated: true)
                }
                
            }
            else {
                SVProgressHUD.dismiss()
                self.target.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
}
