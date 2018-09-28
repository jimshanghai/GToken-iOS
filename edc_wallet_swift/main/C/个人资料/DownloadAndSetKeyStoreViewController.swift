//
//  DownloadAndSetKeyStoreViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/16.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD

class DownloadAndSetKeyStoreViewController: UIViewController,UITextFieldDelegate {
  private var currentOperateTextRect:CGRect!
    @IBOutlet var repass: UITextField!
    @IBOutlet var pass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
         title = NSLocalizedString("设置keystore", comment: "")
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func downloadAction(_ sender: Any) {
        setupSignal(dic: ["password":pass.text! ,"password_confirmation":repass.text! ])
    }
    func setupSignal(dic:NSDictionary){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在保存", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_keystoreset, params: dic as? [String : AnyObject], success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                if(result.object(forKey: "data") != nil ){
                    UserDefaults.standard.set(dic["data"], forKey: "keystorejson")
                    UserDefaults.standard.set("2", forKey: "keystoreUser")//是不是keystore用户  1不是  2
                  self.navigationController?.pushViewController(DownloadSuccessViewController(), animated: true)
                }
            }
            else {
                self.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
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
        let textfieldY = currentOperateTextRect.origin.y + (repass.superview?.frame.origin.y)!
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
