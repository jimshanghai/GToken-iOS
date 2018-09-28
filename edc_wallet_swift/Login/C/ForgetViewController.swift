//
//  ForgetViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/8.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController {
     let forgetVM:ForgetViewModel = ForgetViewModel()
    var currentOperateTextRect:CGRect!
    var isPersonal:Bool!
    @IBOutlet var mobile: UITextField!
    @IBOutlet var smscode: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmpassword: UITextField!
    @IBOutlet var regitsBut: UIButton!
    @IBOutlet var sendSMS: CountDownBtn!
    
    
    
    
    @IBOutlet var TypeSeg: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("忘记密码", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
          forgetVM.target = self
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.darkText,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = leftBarBtn
        if isPersonal == true {
            self.regitsBut.isHidden = true
            self.mobile.isEnabled = false
            if((UserDefaults.standard.object(forKey: "mobile")) != nil){
                self.mobile.text = (UserDefaults.standard.object(forKey: "mobile")as! String)
            }else{
                self.mobile.text = UserDefaults.standard.object(forKey: "email")as? String
                self.TypeSeg.selectedSegmentIndex = 1
                self.typeSegAction(self.TypeSeg)
            }
        }else{
            self.mobile.isEnabled = true
            self.regitsBut.isHidden = false
        }
        mobile.superview?.layer.borderColor = UIColor.lightGray.cgColor
        mobile.superview?.layer.borderWidth = 1.0
        password.superview?.layer.borderColor = UIColor.lightGray.cgColor
        password.superview?.layer.borderWidth = 1.0
        confirmpassword.superview?.layer.borderColor = UIColor.lightGray.cgColor
        confirmpassword.superview?.layer.borderWidth = 1.0
        smscode.superview?.layer.borderColor = UIColor.lightGray.cgColor
        smscode.superview?.layer.borderWidth = 1.0
    }
    @IBAction func typeSegAction(_ sender: Any) {
        if self.TypeSeg.selectedSegmentIndex == 0 {
            if((UserDefaults.standard.object(forKey: "mobile")) != nil){
                self.mobile.text = (UserDefaults.standard.object(forKey: "mobile")as! String)
            }
            self.mobile.placeholder = NSLocalizedString("请输入手机号", comment: "")
        }else{
            if((UserDefaults.standard.object(forKey: "email")) != nil){
                self.mobile.text = (UserDefaults.standard.object(forKey: "email")as! String)
            }
            self.mobile.placeholder = NSLocalizedString("请输入email", comment: "")
        }
    }
    @IBAction func cutDownAction(_ sender: CountDownBtn) {
        
        if self.TypeSeg.selectedSegmentIndex == 1 {
         
            // 这里写其它操作，如获取验证码
            self.forgetVM.sendemailcode(dic: ["email":mobile.text ?? "","type":"reset"])
            
        }else{
            // 这里写其它操作，如获取验证码
            self.forgetVM.sendsms(dic: ["mobile":mobile.text ?? "","type":"reset"])
          
        }
    }
    
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func resetPassword(_ sender: Any) {
        if self.TypeSeg.selectedSegmentIndex == 0 {
            if mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("请输入手机号", comment: ""))
                return
            }
            
        }else{
            if mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("请输入邮箱", comment: ""))
                return
            }
            
        }
        if smscode.text?.lengthOfBytes(using: .utf8) == 0 {
            alertWithClick(msg: NSLocalizedString("请请输入验证码", comment: ""))
            return
        }
        if password.text?.lengthOfBytes(using: .utf8) == 0 || confirmpassword.text?.lengthOfBytes(using: .utf8) == 0{

            alertWithClick(msg: NSLocalizedString("请输入密码", comment: ""))
            return
        }
        
          if self.TypeSeg.selectedSegmentIndex == 0 {
                 self.forgetVM.resetPass(dic: ["mobile":mobile.text ?? "","verification": smscode.text ?? "","password": password.text ?? "","password_confirmation": confirmpassword.text ?? ""])
          }else{
                  self.forgetVM.resetPass(dic: ["email":mobile.text ?? "","verification": smscode.text ?? "","password": password.text ?? "","password_confirmation": confirmpassword.text ?? ""])
        }
  
    }
    
    @IBAction func regist(_ sender: Any) {
      self.navigationController?.pushViewController(RegistViewController(), animated: true)
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
extension ForgetViewController:UITextFieldDelegate{
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notication:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notication:)), name: .UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.removeObserver(self, name:  .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:  .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notication:NSNotification){
        var currentFrame = self.view.frame
        let keyHeight = keyboardEndingFrameHeight(userInfo: notication.userInfo! as NSDictionary)
        let textfieldY = currentOperateTextRect.origin.y + (confirmpassword.superview?.frame.origin.y)!
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
}
