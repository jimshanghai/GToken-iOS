//
//  LoginViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/7.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    let loginVM:LoginViewModel = LoginViewModel()
    
    private var currentOperateTextRect:CGRect!
    
    @IBOutlet var ksloginBut: UIButton!
    @IBOutlet var mobile: UITextField!
    @IBOutlet var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVM.target = self
        // Do any additional setup after loading the view.
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
       mobile.superview?.layer.borderColor = UIColor.lightGray.cgColor
       mobile.superview?.layer.borderWidth = 1.0
       password.superview?.layer.borderColor = UIColor.lightGray.cgColor
        password.superview?.layer.borderWidth = 1.0
        
    }

    @IBAction func forgetTap(_ sender: Any) {
         let forget =   ForgetViewController()
         forget.isPersonal = false
        self.navigationController?.pushViewController(forget, animated: true)
    }
    
    @IBAction func registTap(_ sender: Any) {
        let regist =  RegistViewController()
        regist.isBindUser = false
        self.navigationController?.pushViewController(regist, animated: true)
    }
    
    @IBAction func loginBut(_ sender: Any) {
        if mobile.text?.lengthOfBytes(using: .utf8) == 0{
            alertWithClick(msg: NSLocalizedString("请输入手机号", comment: ""))
            return
        }
        if password.text?.lengthOfBytes(using: .utf8) == 0{
            alertWithClick(msg: NSLocalizedString("请输入密码", comment: ""))
            return
        }
        self.loginVM.loginSignal(dic: ["username":mobile.text ?? "","password":password.text ?? ""])
    }
    @IBAction func keyStoreLogin(_ sender: Any) {
        self.navigationController?.pushViewController(KeystoreLoginViewController(), animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notication:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notication:)), name: .UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.removeObserver(self, name:  .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:  .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notication:NSNotification){
        var currentFrame = self.view.frame
        let keyHeight = keyboardEndingFrameHeight(userInfo: notication.userInfo! as NSDictionary)
        let textfieldY = currentOperateTextRect.origin.y + (password.superview?.frame.origin.y)!
//        let barHeight = UIScreen.main.bounds.height == 812 ? 88:64
        let subvalue =  UIScreen.main.bounds.height - keyHeight - textfieldY   - 108
        if(subvalue < 0 ){
            currentFrame.origin.y = subvalue
        }
        self.view.frame = currentFrame
     }
    @objc func keyboardWillHide(notication:NSNotification){
        let userinfo = notication.userInfo! as NSDictionary
        let keyBoardDurationValue = userinfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey)
        var originalFrame = self.view.frame
        originalFrame.origin.y = 0
        UIView.animate(withDuration: keyBoardDurationValue as! TimeInterval) {
            self.view.frame = originalFrame
        }
    }
    func keyboardEndingFrameHeight(userInfo:NSDictionary) -> CGFloat {
        let value = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = value.cgRectValue
        return keyboardRect.size.height
    }
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentOperateTextRect = textField.frame
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
