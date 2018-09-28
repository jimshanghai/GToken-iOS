//
//  RegistViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/8.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController,ChangeCity,UITextFieldDelegate{
    @IBOutlet var AreaWidth: NSLayoutConstraint!
    @IBOutlet var GenderSEG: UISegmentedControl!
    @IBOutlet var registerSelectSEG: UISegmentedControl!
    @IBOutlet var keystoreLable: UILabel!
    let registerVM:RegistViewModel = RegistViewModel()
    private var currentOperateTextRect:CGRect!
    @IBOutlet var arreButton: UIButton!
    @IBOutlet var mobile: UITextField!
    @IBOutlet var smscode: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmpassword: UITextField!
    @IBOutlet var name: UITextField!
    var gender: Int = 1
    @IBOutlet var sendSMS: CountDownBtn!
    
    
    var isBindUser: Bool = false
     var address: String!
    
    
    @IBAction func RegisterTypeSelect(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.arreButton.isHidden = false;
            self.mobile.placeholder = NSLocalizedString("请输入手机号", comment: "")
            self.AreaWidth.constant = 120.0
        }else{
            self.arreButton.isHidden = true;
            self.mobile.placeholder = NSLocalizedString("请输入email", comment: "")
            self.AreaWidth.constant = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isBindUser == true{
            self.title = NSLocalizedString("绑定用户", comment: "")
            self.keystoreLable.isHidden = false
            self.keystoreLable.text = "您的Token地址:\n" + address
            self.registerSelectSEG.isHidden = true

        }else{
            self.keystoreLable.isHidden = true
            self.registerSelectSEG.isHidden = true
            self.keystoreLable.text = ""
            self.title = NSLocalizedString("注册", comment: "")
            
       
        }
        self.edgesForExtendedLayout = []
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.darkText,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        self.registerVM.target = self
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        
        mobile.superview?.layer.borderColor = UIColor.lightGray.cgColor
        mobile.superview?.layer.borderWidth = 1.0
        password.superview?.layer.borderColor = UIColor.lightGray.cgColor
        password.superview?.layer.borderWidth = 1.0
        smscode .superview?.layer.borderColor = UIColor.lightGray.cgColor
        smscode.superview?.layer.borderWidth = 1.0
        confirmpassword.superview?.layer.borderColor = UIColor.lightGray.cgColor
        confirmpassword.superview?.layer.borderWidth = 1.0
        name.superview?.layer.borderColor = UIColor.lightGray.cgColor
        name.superview?.layer.borderWidth = 1.0
        
        let font =  UIFont.systemFont(ofSize: 17.0);
        
        let  registeSEG = UISegmentedControl(items: [NSLocalizedString("手机号注册", comment: ""),NSLocalizedString("邮箱注册", comment: "")])
        registeSEG.frame = CGRect(x:21, y:15 ,width: kScreenWidth - 42, height: 40)
        registeSEG.setTitleTextAttributes([NSAttributedStringKey.font : font], for: .normal)
        registeSEG.selectedSegmentIndex = 0;
        registeSEG .setTitleTextAttributes([NSAttributedStringKey.font : font], for: .normal)
        registeSEG.addTarget(self, action: #selector(RegisterTypeSelect(_:)), for: .valueChanged)
        view.addSubview(registeSEG)
        
        let  genderS = UISegmentedControl(items: [NSLocalizedString("男", comment: ""),NSLocalizedString("女", comment: ""),])
        genderS.frame = CGRect(x:21, y: (name.superview?.frame.origin.y)! + 30, width: kScreenWidth - 42, height: 40)
        genderS.selectedSegmentIndex = 0;
        genderS .setTitleTextAttributes([NSAttributedStringKey.font : font], for: .normal)
        genderS.addTarget(self, action: #selector(genderSelect(_:)), for: .valueChanged)
        view.addSubview(genderS)
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }

    @IBAction func registeBut(_ sender:Any) {
        print(self.registerSelectSEG.selectedSegmentIndex)
        if  self.arreButton.isHidden ==  false{
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
            alertWithClick(msg: NSLocalizedString("请输入验证码", comment: ""))
            return
        }
        if password.text?.lengthOfBytes(using: .utf8) == 0 || confirmpassword.text?.lengthOfBytes(using: .utf8) == 0{
            
            alertWithClick(msg: NSLocalizedString("请输入密码", comment: ""))
            return
        }
        if name.text?.lengthOfBytes(using: .utf8) == 0 {
            alertWithClick(msg: NSLocalizedString("请输入姓名", comment: ""))
            return
        }
        if isBindUser {
               if  self.arreButton.isHidden ==  false {
                    self.registerVM.regitser(dic: ["mobile":mobile.text ?? "","areas":arreButton.titleLabel?.text ?? "","name": name.text ?? "","verification": smscode.text ?? "","password": password.text ?? "","password_confirmation": confirmpassword.text ?? "","sex": String(format: "%d", gender),"keystore": UserDefaults.standard.object(forKey: "keystorejson")!])

               }else{
                     self.registerVM.regitser(dic: ["email":mobile.text ?? "","name": name.text ?? "","verification": smscode.text ?? "","password": password.text ?? "","password_confirmation": confirmpassword.text ?? "","sex": String(format: "%d", gender),"keystore": UserDefaults.standard.object(forKey: "keystorejson")!])
            }

        }else{

            if  self.arreButton.isHidden ==  false {
                self.registerVM.regitser(dic: ["mobile":mobile.text ?? "","areas":arreButton.titleLabel?.text ?? "","name": name.text ?? "","verification": smscode.text ?? "","password": password.text ?? "","password_confirmation": confirmpassword.text ?? "","sex": String(format: "%d", gender)])
            }else{
                self.registerVM.regitser(dic: ["email":mobile.text ?? "","name": name.text ?? "","verification": smscode.text ?? "","password": password.text ?? "","password_confirmation": confirmpassword.text ?? "","sex": String(format: "%d", gender),])
            }
        }
        
        
    }
    
    @IBAction func areaBut(_ sender: Any) {
       let city =   CityListViewController()
        city.delegate = self
        self.navigationController?.pushViewController(city, animated: true)
    }
    
    @IBAction func cutDown(_ sender: CountDownBtn) {
         if  self.arreButton.isHidden ==  true{
            if mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                
                alertWithClick(msg: NSLocalizedString("请输入邮箱", comment: ""))
                return
            }
            // 这里写其它操作，如获取验证码
            self.registerVM.sendemailcode(dic: ["email":mobile.text ?? ""])
            
        }else{
           
            if mobile.text?.lengthOfBytes(using: .utf8) == 0 {
                
                alertWithClick(msg: NSLocalizedString("请输入手机号", comment: ""))
                return
            }
            if arreButton.titleLabel?.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("请选择手机号所属地区", comment: ""))
                return
            }
            // 这里写其它操作，如获取验证码
            self.registerVM.sendsms(dic: ["mobile":mobile.text ?? "","area":arreButton.titleLabel?.text ?? ""])
        }
        
       
    }
    
    @IBAction func genderSelect(_ sender: UISegmentedControl) {
       gender = sender.selectedSegmentIndex
    }
    @IBAction func copyrightBut(_ sender: Any) {
        let  find = FindViewController()
         find.type = 2;
         self.navigationController?.pushViewController(find, animated: true)
    }
    
    @IBAction func personalBut(_ sender: Any) {
         let  find = FindViewController()
         find.type = 2;
          self.navigationController?.pushViewController(find, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notication:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notication:)), name: .UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name:  .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:  .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notication:NSNotification){
        var currentFrame = self.view.frame
        let keyHeight = keyboardEndingFrameHeight(userInfo: notication.userInfo! as NSDictionary)
        let textfieldY = currentOperateTextRect.origin.y
        let subvalue =  UIScreen.main.bounds.height - keyHeight - textfieldY
        if(subvalue < 0 ){
            currentFrame.origin.y = subvalue
        }
        self.view.frame = currentFrame
    }
    @objc func keyboardWillHide(notication:NSNotification){
        let userinfo = notication.userInfo! as NSDictionary
        let keyBoardDurationValue = userinfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey)
        var originalFrame = self.view.frame
        originalFrame.origin.y = kNavBarHeight_StatusHeight(self)
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
        currentOperateTextRect = textField.superview?.frame
    }
    
    func ChangeCityWithCityName(cityName: String) {
       arreButton.setTitle(cityName, for: UIControlState.normal)
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
