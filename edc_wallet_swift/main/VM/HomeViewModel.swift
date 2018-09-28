
//
//  HomeViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/17.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewModel: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    weak var target:HomeViewController!
    var walletlistarray:NSArray!
    var selectModel:WalletlistModel!
    
    func walletlistSignal(){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let  urlStr  =  UserDefaults.standard.object(forKey: "avatar")as!String
        let urlwithPercentEscapes = urlStr.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url = URL.init(string: urlwithPercentEscapes!)
        self.target.avatar.setImageWith(url!, placeholderImage: UIImage(named: "缺省头像"))
        self.target.name.text =  UserDefaults.standard.object(forKey: "name") as? String
        self.target.number.text =  UserDefaults.standard.object(forKey: "numbers") as? String
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
                self.walletlistarray = (list.copy() as! NSArray)
                self.target.table.reloadData()
                self.target.table.mj_header.endRefreshing()
            }
            else {
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String))
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            let dic  = (error! as NSError).userInfo as NSDictionary
            print(dic.object(forKey: "NSLocalizedDescription")!)
            if(dic.object(forKey: "NSLocalizedDescription") as! String ==  "Request failed: unauthorized (401)"){
                UIApplication.shared.delegate?.window??.backgroundColor = UIColor.white
                let loginvc = LoginViewController();
                let nav = UINavigationController.init(rootViewController: loginvc)
                UIApplication.shared.delegate?.window??.rootViewController = nav
                
            }else{
                    self.target.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            }
        }
        
    }
    func transationslistSignal(dic:NSDictionary) {
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_transactionslist, params: dic as? [String : AnyObject], success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as?Int == 200 ){
                
                let list:NSMutableArray = NSMutableArray()
                let array = result["data"] as!NSArray
                for dic in array {
                    let model = try? LsqDecoder.decode(TransationModel.self, param: dic as! [String : Any])
                    list.add(model as Any)
                }
                let detail = DetailViewController()
                detail.slewalletlistmodel = self.selectModel
                detail.detailVM.transationslistarray = list.copy() as? NSArray
                let balanceStr = "\(result["balance"] ?? "")"
                let banlanceValue = NSString(string: balanceStr).doubleValue
                detail.detailVM.banlance = banlanceValue
                detail.detailVM.contract_id = (dic["token"] as! String)
                UserDefaults.standard.set(detail.detailVM.banlance, forKey: "balance")
                self.target.navigationController?.pushViewController(detail, animated: true)
            }
            else {
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String))
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            
        }
        
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
        cell?.number.text = String(format: "%.3f", model.balance)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let model = walletlistarray.object(at: indexPath.row) as! WalletlistModel
         selectModel = model
         transationslistSignal(dic: ["token":model.contract_id])
    }
    
    
//    func loadStatus()-> RACSignal{
//
//        return RACSignal.createSignal({ (subscribe) -> RACDisposable! in
//
//            NetworkTools.sharedTools.loadStatus().subscribeNext({ (result) -> Void in
//
//                //1.获取网络数据，加载到字典数组中
//                guard let array = result["statuses"] as? [[String: AnyObject]] else{
//                    return
//                }
//
//                //2.字典转模型
//                if self.status == nil{
//                    //初始化Status模型的字典
//                    self.status = [Status]()
//                }
//
//                //3.遍历模型
//                for dic in array{
//                    self.status?.append(Status(dic: dic))
//                }
//
//                subscribe.sendCompleted()
//
//            }, error: { (error) -> Void in
//
//                subscribe.sendError(error)
//
//            }) {}
//            return nil
//        })
//
//    }
    
}
