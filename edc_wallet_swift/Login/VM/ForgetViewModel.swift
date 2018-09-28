//
//  ForgetViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/21.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD
class ForgetViewModel: NSObject {
 weak var target:ForgetViewController!
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
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
    func resetPass(dic:NSDictionary){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_resetPassword, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            SVProgressHUD.dismiss()
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                let alertController = UIAlertController(title: "重置成功!",
                                                        message: nil, preferredStyle: .alert)
                //显示提示框
                self.target.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                   self.target.presentedViewController?.dismiss(animated: false, completion: nil)
                   self.target.navigationController?.popViewController(animated: true)
                }
                
            }
            else {
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String))
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
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
            if(result.object(forKey: "code")as? Int == 200 ){
                // 开启倒计时
                self.target.sendSMS.count = 60
                self.target.sendSMS.numberColor = UIColor.white
                self.target.sendSMS.startCountDown()
            }else{
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String) )
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
    
}
