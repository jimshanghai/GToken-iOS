//
//  KeyStoreViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/2.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD
class KeyStoreViewModel: NSObject {
    weak var target:KeystoreLoginViewController!
    //发送ks
    func isExistKeyStore(dic:NSDictionary){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_isExistKeyStore, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            SVProgressHUD.dismiss()
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                  //login
                  UserDefaults.standard.set(self.target.textView.text, forKey: "keystorejson")
                    let login =  KLoginPrivateViewController()
                    self.target.navigationController?.pushViewController(login, animated: true)
            }else{
                if(result.object(forKey: "code")as? Int == 201){
                  //绑定
                    UserDefaults.standard.set(self.target.textView.text, forKey: "keystorejson")
                    let regist =  BindViewController()
                    regist.addressStr = self.target.address
                    self.target.navigationController?.pushViewController(regist, animated: true)
                }
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
}
