
//
//  OutDetail2ViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/20.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD

class OutDetail2ViewModel: UIView,UITableViewDelegate,UITableViewDataSource {
    weak var target:OutDetail2ViewController!
      var walletlistarray:NSArray!
     var contract_id:String!
     var tonumbers:String!
     var usersInfo:NSDictionary!
    
    var selectwalletlistModel:WalletlistModel!
    
    
    func walletlistSignal(){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_walletlist, params: nil, success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as?Int == 200 ){
                let list:NSMutableArray = NSMutableArray()
                let array = result["data"] as!NSArray
                for dic in array {
                    let model = try? LsqDecoder.decode(WalletlistModel.self, param: dic as! [String : Any])
                    list.add(model as Any)
                }
                self.walletlistarray = list.copy() as! NSArray
                self.target.kindlist.isHidden = false
                
                self.target.tableHeight.constant = CGFloat(120 * self.walletlistarray.count)
                self.target.kindlist.reloadData()
            }
            else {
                self.target.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            
        }
        
    }
    
    
    func nextStepSignal(){
        if self.target.count.text?.lengthOfBytes(using: .utf8) == 0 {
            
            self.target.alertWithClick(msg: NSLocalizedString("请输入数量", comment: ""))
            return
        }
        if self.target.kindTitle.text == "-------" {
              self.target.alertWithClick(msg: "选择交易Token种类")
            return
        }
        if  UserDefaults.standard.object(forKey: "keystoreUser") as! String == "1"{
            let confirm = ConfirmViewController()
            confirm.userinfoDic = self.usersInfo
            confirm.resultDic = ["contract":contract_id,"val":self.target.count.text!,"numbers":tonumbers,"abbreviation": self.selectwalletlistModel.symbol,"remarks": self.target.marks.text!,"zh_name": self.selectwalletlistModel.zh_name]
            self.target.navigationController?.pushViewController(confirm, animated: true)
      }else{
          self.confirm(title:  NSLocalizedString("温馨提示", comment: ""), message: NSLocalizedString("请输入keystore密码", comment: ""), controller: self.target, textplaceholder:  NSLocalizedString("请输入keystore密码", comment: ""))
    }
}
     func confirm(title:String?,message:String?,controller:UIViewController,textplaceholder:String)
    {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addTextField { (textfiled) in
            textfiled.placeholder = textplaceholder
            textfiled.borderStyle = .roundedRect
            textfiled.isSecureTextEntry = true
        }
        let entureAction = UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .destructive) { (action:UIAlertAction) -> ()in
            let confirm = ConfirmViewController()
            confirm.userinfoDic = self.usersInfo
            let pwd = (alertVC.textFields![0] as UITextField).text
            confirm.resultDic = ["contract":self.contract_id,"val":self.target.count.text!,"numbers":self.tonumbers,"abbreviation": self.selectwalletlistModel.symbol,"remarks": self.target.marks.text!,"zh_name": self.selectwalletlistModel.zh_name,"keystorepsd":pwd!  as String]
            self.target.navigationController?.pushViewController(confirm, animated: true)
        }
        alertVC.addAction(entureAction)
        controller.present(alertVC, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.walletlistarray == nil {
            return 0
        }
        return self.walletlistarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let model = walletlistarray.object(at: indexPath.row) as! WalletlistModel
        cell?.avatar.setImageWith(NSURL(string: model.icon)! as URL, placeholderImage: UIImage(named: "缺省头像"))
        cell?.name.text = model.zh_name
        cell?.number.text = " "
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let model = walletlistarray.object(at: indexPath.row) as! WalletlistModel
         self.target.kindlist.isHidden = false
         self.selectwalletlistModel = model
         self.target.tableHeight.constant = 0
         self.target.kindTitle.text = model.zh_name
         contract_id = model.contract_id
         if model.icon != nil {
            self.target.kindAvatar.setImageWith(NSURL(string: model.icon)! as URL)
         }else{
            self.target.kindAvatar.image = UIImage(named: "缺省头像")
        }
         self.target.after.text = String (format: "可用余额:%.3f",model.balance)
         self.target.title = String(format: "%@交易详情", model.zh_name)
    }
    func getInfoSignal(){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_getInfo, params: ["numbers":self.tonumbers as AnyObject], success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                
                self.target.toname.text = (result["data"] as! NSDictionary) ["name"] as? String
                self.target.toavatar.setImageWith(NSURL(string: ((result["data"] as! NSDictionary) ["avatar"] as? String)!)! as URL)
                self.usersInfo = NSDictionary(dictionary: ["to_name": self.target.toname.text!,"to_avatar": (result["data"] as! NSDictionary) ["avatar"] as? String? as Any])
            }
            else {
                self.target.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
}
