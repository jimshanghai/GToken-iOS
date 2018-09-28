//
//  OutdetailViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/20.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD

class OutdetailViewModel: NSObject {
    weak var target:OutDetailViewController!
    var contract_id :String!
    
    func contractsSignal() {
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_userContactlist, params: nil , success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as?Int == 200 ){
                
                let list:NSMutableArray = NSMutableArray()
                let array = result["data"] as!NSArray
                for dic in array {
                    let model = try? LsqDecoder.decode(ContractModel.self, param: dic as! [String : Any])
                    list.add(model as Any)
                }
                let detail = ContactViewController()
//                detail.Contractlistarray = list.copy() as! NSArray
                detail.delegate = self.target
                  
                self.target.navigationController?.pushViewController(detail, animated: true)
            }
            else {
                self.target.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            
        }
        
    }
    func nextActionSignal(dics:NSDictionary) {
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_istransfer, params: (dics as! [String : AnyObject]) , success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as?Int == 200 ){
                let dic = result["data"] as!NSDictionary
                let confirm = ConfirmViewController()
                
             confirm.userinfoDic = dic
             confirm.resultDic = ["contract":self.contract_id,"val":self.target.count.text!,"numbers":self.target.address.text!,"remarks": self.target.remark.text!,"abbreviation":dic["abbreviation"]as!String  ,"zh_name": dic["title"]as!String ]
            if  UserDefaults.standard.object(forKey: "keystoreUser") as! String == "2"{
                confirm.resultDic = ["contract":self.contract_id,"val":self.target.count.text!,"numbers":self.target.address.text!,"remarks": self.target.remark.text!,"abbreviation":dic["abbreviation"]as!String  ,"zh_name": dic["title"]as!String,"keystorepsd":dics["keystorepsd"]as! String ]
                }
               
                self.target.navigationController?.pushViewController(confirm, animated: true)
            }
            else {
                self.target.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            
        }
        
    }
   
}
