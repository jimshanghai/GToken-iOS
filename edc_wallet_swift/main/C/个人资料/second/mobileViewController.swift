//
//  mobileViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/23.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
//声明一个protocal，必须继承NSObjectProtocal
protocol mobileChange:NSObjectProtocol{
    func mobilechangeWithNumber(number:String , code:String)
}

class mobileViewController: UIViewController {
    @IBOutlet var button: CountDownBtn!
    
    @IBOutlet var code: UITextField!
    @IBOutlet var mobile: UITextField!
    weak var delegate:mobileChange!
    var mobileStr:String!
    var isEmail:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEmail == true {
            title = NSLocalizedString("设置邮箱", comment: "")
            mobile.placeholder = "输入邮箱"
        }else{
          title = NSLocalizedString("设置手机号", comment: "")
             mobile.placeholder = "输入手机号"
        }
        
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        self.mobile.text = self.mobileStr
        mobile.layer.borderColor = UIColor.lightGray.cgColor
        mobile.layer.borderWidth = 1.0
        code.layer.borderColor = UIColor.lightGray.cgColor
        code.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
    }
    @IBAction func cutDownAction(_ sender: CountDownBtn) {
        if isEmail == true {
            if mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("请输入邮箱", comment: ""))
                return
            }
            self.sendsms(dic: ["email":mobile.text ?? "","type":"update"])
        }else{
            if mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("请输入手机号", comment: ""))
                return
            }
            self.sendsms(dic: ["mobile":mobile.text ?? "","type":"update"])
        }
    }
    
    func sendsms(dic:NSDictionary ){
        var  urlStr:String  = ""
        
        if isEmail == true {
          urlStr = API_email
        }else{
          urlStr = API_sms
        }
        NetworkTools.shareInstance.request(methodType: .POST, urlString: urlStr, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let dic = obj as! NSDictionary
            if(dic["code"] as? Int == 200){
                // 开启倒计时
                self.button.count = 60
                self.button.numberColor = UIColor.white
                self.button.startCountDown()
            }else{
                if(dic["code"] as? String == "200"){
                    // 开启倒计时
                    self.button.count = 60
                    self.button.numberColor = UIColor.white
                    self.button.startCountDown()
                }else{
                         self.alertWithClick(msg: dic["msg"] as!String)
                }
            }
        }) { (error) in
            self.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        if isEmail == true {
            if(UserDefaults.standard.object(forKey: "email") == nil ){
                if   mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                if    code.text?.lengthOfBytes(using: .utf8) == 0 {
                    alertWithClick(msg: NSLocalizedString("请输入验证码", comment: ""))
                    return
                }
                self.delegate.mobilechangeWithNumber(number: self.mobile.text!, code: self.code.text!)
                self.navigationController?.popViewController(animated: true)
                return
            }
            if  (UserDefaults.standard.object(forKey: "email") as? String != self.mobile.text!){
                if code.text?.lengthOfBytes(using: .utf8) == 0 {
                    alertWithClick(msg: NSLocalizedString("请输入验证码", comment: ""))
                    return
                }
                self.delegate.mobilechangeWithNumber(number: self.mobile.text!, code: self.code.text!)
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else{
          if(UserDefaults.standard.object(forKey: "mobile") == nil ){
            if   mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                self.navigationController?.popViewController(animated: true)
                return
            }
            if    code.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("请输入验证码", comment: ""))
                return
            }
             self.delegate.mobilechangeWithNumber(number: self.mobile.text!, code: self.code.text!)
            self.navigationController?.popViewController(animated: true)
        }
             if  (UserDefaults.standard.object(forKey: "mobile") as? String != self.mobile.text!){
                if code.text?.lengthOfBytes(using: .utf8) == 0 {
                    alertWithClick(msg: NSLocalizedString("请输入验证码", comment: ""))
                    return
                }
                self.delegate.mobilechangeWithNumber(number: self.mobile.text!, code: self.code.text!)
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
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
        let okAction = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
