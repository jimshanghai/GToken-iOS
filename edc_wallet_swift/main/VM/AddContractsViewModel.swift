//
//  AddContracts.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/20.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddContractsViewModel: NSObject {
    
    weak var target:AddContactViewController!
    
    func addcontractsSignal(dic:NSDictionary) {
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_addcontact, params: dic as? [String : AnyObject], success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as?Int == 200 ){
             self.target.navigationController?.popViewController(animated: true)
            }
            else {
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String))
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            
        }
        
    }
}
