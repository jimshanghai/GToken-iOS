//
//  OutDetailViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class OutDetailViewController: UIViewController ,seletcontact{
    
    var selectwalletlistmodel :WalletlistModel!
    
    
    func seletcontactwithNumber(numbers: String) {
      address.text = numbers
    }
    
    let outVM:OutdetailViewModel = OutdetailViewModel()
    @IBOutlet internal var after: UILabel!
     @IBOutlet internal var msgLable: UILabel!
    @IBOutlet internal var address: UITextField!
    @IBOutlet internal var count: UITextField!
    @IBOutlet internal var remark: UITextView!
    var banlance:Double!
    
    var currentOperateTextRect:CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(format: "%@转出详情", self.selectwalletlistmodel.zh_name)
            self.edgesForExtendedLayout = []
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.after.text = String (format: "%@:%.3f",NSLocalizedString("可用余额", comment: ""), self.banlance)
        self.outVM.target = self
        remark.delegate = self
        address.layer.borderColor = UIColor.lightGray.cgColor
        address.layer.borderWidth = 1.0
        count.layer.borderColor = UIColor.lightGray.cgColor
        count.layer.borderWidth = 1.0
        remark.layer.borderColor = UIColor.lightGray.cgColor
        remark.layer.borderWidth = 1.0
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func contactsButton(_ sender: Any){
        self.outVM.contractsSignal()
//        self.navigationController?.pushViewController(ContactViewController(), animated: true)
    }
    @IBAction func nextButton(_ sender: Any){
        if address.text?.lengthOfBytes(using: .utf8) == 0 {
            
            alertWithClick(msg: NSLocalizedString("请输入转账地址", comment: ""))
            return
        }
        if count.text?.lengthOfBytes(using: .utf8) == 0 {
            alertWithClick(msg: NSLocalizedString("请输入数量", comment: ""))
            return
        }
        if  UserDefaults.standard.object(forKey: "keystoreUser") as! String == "1"{
             self.outVM.nextActionSignal(dics:["contract":outVM.contract_id,"val":count.text!,"numbers":address.text!])
        }else{
            self.confirm(title:  NSLocalizedString("温馨提示", comment: ""), message: NSLocalizedString("请输入keystore密码", comment: ""), controller: self, textplaceholder:  NSLocalizedString("请输入keystore密码", comment: ""))
        }
       
    }
    @IBAction func cancelButton(_ sender: Any){
      self.navigationController?.popViewController(animated: true)
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
    
    func confirm(title:String?,message:String?,controller:UIViewController,textplaceholder:String)
    {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addTextField { (textfiled) in
            textfiled.placeholder = textplaceholder
            textfiled.borderStyle = .roundedRect
            textfiled.isSecureTextEntry = true
        }
        let entureAction = UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .destructive) { (action:UIAlertAction) -> ()in
            let pwd = (alertVC.textFields![0] as UITextField).text
            self.outVM.nextActionSignal(dics:["contract":self.outVM.contract_id,"val":self.count.text!,"numbers":self.address.text!,"keystorepsd":pwd! as String ])
        }
        alertVC.addAction(entureAction)
        controller.present(alertVC, animated: true, completion: nil)
        
    }

}

extension OutDetailViewController:UITextFieldDelegate,UITextViewDelegate{
    
    
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
        let textfieldY = currentOperateTextRect.origin.y
        //        let barHeight = UIScreen.main.bounds.height == 812 ? 88:64
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
        currentOperateTextRect = textField.frame
    }
    // 文本框将要开始编辑
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       currentOperateTextRect = textView.frame
        return true
    }
}
