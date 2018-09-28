//
//  PersonalViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/21.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController,mobileChange,nameChange {
  
    
    let personalVM:PersonalViewModel  = PersonalViewModel()
    
    @IBAction func copyAddress(_ sender: Any) {
        UIPasteboard.general.string = gongaaddress.text
        let alertController = UIAlertController(title: "复制成功!",
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    @IBOutlet var gongaaddress: UILabel!
    @IBOutlet var mobile: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    var code:String!
    var emailCode:String!
    
    
    @IBAction func avatarBut(_ sender: Any) {
        
        Tool.shareTool.choosePicture(self, editor: true, options:[.camera,.photoLibrary]) {[weak self] (image) in
            self?.personalVM.getQiniuSignal(image: image)
   
            
        }
       
    }
    func mobilechangeWithNumber(number: String, code: String) {
        if number.contains("@") {
             self.email.text = number
             self.emailCode = code
        }else{
             self.mobile.text = number
             self.code = code
        }
    }
    func namechangeWithName(name: String) {
        self.name.text = name
    }
    @IBAction func nameBut(_ sender: Any) {
        let name = NameViewController()
        name.delegate = self
        name.nameStr = self.name.text
        self.navigationController?.pushViewController(name, animated: true)
    }
    @IBAction func emailBut(_ sender: Any) {
        let mobile = mobileViewController()
        mobile.isEmail = true
        mobile.mobileStr = self.email.text
        mobile.delegate = self
        self.navigationController?.pushViewController(mobile, animated: true)
    }
    @IBAction func mobileBut(_ sender: Any) {
        let mobile = mobileViewController()
        mobile.isEmail = false
        mobile.mobileStr = self.mobile.text
        mobile.delegate = self
        self.navigationController?.pushViewController(mobile, animated: true)
    }
    @IBOutlet var avatar: UIImageView!
    @IBAction func loginoutBut(_ sender: Any) {
      UserDefaults.standard.set("loginout", forKey: "access_token")
      UIApplication.shared.delegate?.window??.backgroundColor = UIColor.white
     let loginvc = LoginViewController();
     let nav = UINavigationController.init(rootViewController: loginvc)
     UIApplication.shared.delegate?.window??.rootViewController = nav
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("个人中心", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.personalVM.target = self;
        self.personalVM.getInfoSignal()
        self.avatar.setImageWith(NSURL(string: UserDefaults.standard.object(forKey: "avatar")as!String)! as URL, placeholderImage: UIImage(named:"缺省头像"))
        self.gongaaddress.text = (UserDefaults.standard.object(forKey: "private_address_gongga")as! String)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
      if(code == nil && emailCode == nil ){
           self.personalVM.saveInfoSignal(dic: ["avatar":self.personalVM.AvatarUrl,"name":self.name.text!])
        }
        if(code != nil && emailCode != nil ){
             self.personalVM.saveInfoSignal(dic: ["avatar":self.personalVM.AvatarUrl,"name":self.name.text!,"mobile":self.mobile.text!,"verification":code!,"email":self.email.text!,"verification":emailCode!])
        }else{
            if(code != nil && UserDefaults.standard.object(forKey: "mobile") as? String != self.mobile.text!){
                    self.personalVM.saveInfoSignal(dic: ["avatar":self.personalVM.AvatarUrl,"name":self.name.text!,"mobile":self.mobile.text!,"verification":code!])
            }
            if(emailCode != nil && UserDefaults.standard.object(forKey: "email") as? String != self.email.text!){
                   self.personalVM.saveInfoSignal(dic: ["avatar":self.personalVM.AvatarUrl,"name":self.name.text!,"email":self.email.text!,"verification":emailCode!])
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

