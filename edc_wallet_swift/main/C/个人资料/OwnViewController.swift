//
//  OwnViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/10.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
//import SDWebImage

class OwnViewController: UIViewController {
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var number: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var table: UITableView!
    var array_icon :NSArray = []
    var array_name :NSArray = []
    
    @IBAction func avatarTap(_ sender: Any) {
       self.navigationController?.pushViewController(PersonalViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
       self.navigationItem.title = NSLocalizedString("我的", comment: "")
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.darkText,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        self.table.register(UINib(nibName: "OwnCell", bundle: nil), forCellReuseIdentifier: "OwnCell")
        self.table.tableFooterView = UIView.init()
        array_name = [NSLocalizedString("联系人", comment: ""),NSLocalizedString("个人中心", comment: ""),NSLocalizedString("修改Gtoken登录密码",comment:""),NSLocalizedString("管理Keystore及密码",comment:"")]
        array_icon = ["联系人","个人中心","登录密码","管理钥匙"]
        self.avatar.layer.cornerRadius = 65/2
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 1.0;
        self.avatar.setImageWith(NSURL(string: UserDefaults.standard.object(forKey: "avatar")as!String)! as URL, placeholderImage: UIImage(named: "缺省头像"))
        self.name.text =  UserDefaults.standard.object(forKey: "name") as? String
        self.number.text =  UserDefaults.standard.object(forKey: "numbers") as? String
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(update_avatar),
                                               name:  Notification.Name(rawValue: "avatar_update"), object: nil)
    }
    @objc func update_avatar() -> Void {
        self.avatar.setImageWith(NSURL(string: UserDefaults.standard.object(forKey: "avatar")as!String)! as URL, placeholderImage: UIImage(named: "缺省头像"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension  OwnViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_icon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "OwnCell") as? OwnCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.icon.image = UIImage.init(named:array_icon[indexPath.row] as! String )
        cell?.name.text = (array_name[indexPath.row] as! String)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let  contract = ContactViewController()
            contract.isPersonal = true
            self.navigationController?.pushViewController(contract, animated: true)
            break
        case 1:
         self.navigationController?.pushViewController(PersonalViewController(), animated: true)
  
            break
        case 2:
            if( UserDefaults.standard.object(forKey: "mobile") == nil  ){
                
                if( UserDefaults.standard.object(forKey: "email") == nil  ){
                    alertWithClick(msg:  NSLocalizedString("您可以绑定一个手机或邮箱号码，设置一个Gongga密码，然后用Gongga账号管理您的数字资产", comment: ""))
                }else{
                    let  next = ForgetViewController()
                    next.isPersonal = true
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
            }else{
                let  next = ForgetViewController()
                next.isPersonal = true
                self.navigationController?.pushViewController(next, animated: true)
            }
         
            break
        case 3:
            let str:String  =   UserDefaults.standard.object(forKey: "keystoreUser") as! String//是不是keystore用户  1不是  2
            if str == "1"{
                self.navigationController?.pushViewController(DownloadAndSetKeyStoreViewController(), animated: true)
            }else{
                self.navigationController?.pushViewController(ManageKeyStoreViewController(), animated: true)
            }
            break
        default: break
            
        }
      }
    func alertWithClick(msg:String!) -> Void {
        let alertController = UIAlertController(title: NSLocalizedString("温馨提示", comment: ""),
                                                message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
