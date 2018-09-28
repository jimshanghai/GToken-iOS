//
//  ConfirmViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    var resultDic : NSDictionary!
    var userinfoDic : NSDictionary!
    let confirmVM:ConfirmOutViewModel = ConfirmOutViewModel()
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var toavatar: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var toname: UILabel!
    
    @IBOutlet var kindTitle: UILabel!
    @IBOutlet var countLable: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var marks: UILabel!
    @IBOutlet var create_at: UILabel!
    
    @IBAction func confirmAction(_ sender: Any) {
        confirmVM.nextActionSignal(dic: self.resultDic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmVM.target = self
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        title = String(format: "%@交易详情", self.resultDic.object(forKey: "zh_name") as! String)
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.toavatar.layer.cornerRadius = 50/2
        self.toavatar.layer.masksToBounds = true
        self.toavatar.layer.borderColor = UIColor.white.cgColor
        self.toavatar.layer.borderWidth = 1.0;
        let toavatar = self.userinfoDic["to_avatar"]
        if toavatar != nil {
            self.toavatar.setImageWith(NSURL(string: toavatar as! String)! as URL, placeholderImage: UIImage(named: "缺省头像"))
        }else{
            self.toavatar.image =  UIImage(named: "缺省头像")
        }
        
        self.confirmVM.target = self
        self.avatar.layer.cornerRadius = 50/2
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 1.0;
        self.avatar.setImageWith(NSURL(string: UserDefaults.standard.object(forKey: "avatar")as!String)! as URL, placeholderImage: UIImage(named: "缺省头像"))
        self.name.text =  UserDefaults.standard.object(forKey: "name")as?String
        self.toname.text = self.userinfoDic["to_name"] as? String
        
        self.count.text = (self.resultDic["val"] as? String)! + NSLocalizedString("个", comment: "")
        self.countLable.text = (self.resultDic["val"] as? String)! + NSLocalizedString("个", comment: "")
        self.kindTitle.text = self.resultDic["abbreviation"] as? String
        self.create_at.text =  getCurrentTime()
        self.marks.text = self.resultDic["remarks"] as? String
        
    }
    func getCurrentTime() -> String{
        
        let date = NSDate.init(timeIntervalSinceNow: 0)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = "\(dateformatter.string(from: date as Date))"
        return str
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func alertWithClick(msg:String!) -> Void {
        let alertController = UIAlertController(title: NSLocalizedString("温馨提示", comment: ""),
                                                message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
