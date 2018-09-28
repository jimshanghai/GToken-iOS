//
//  OutDetail2ViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class OutDetail2ViewController: UIViewController {
    let out2VM:OutDetail2ViewModel = OutDetail2ViewModel()
    
    
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var toavatar: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var toname: UILabel!
    
    @IBOutlet var kindAvatar: UIImageView!
    @IBOutlet var kindTitle: UILabel!
    
    @IBOutlet var kind: UITextField!
    @IBOutlet var count: UITextField!
    @IBOutlet var marks: UITextView!
    
    
    @IBOutlet var kindlist: UITableView!
    @IBOutlet var after: UILabel!
    
    
    private var currentOperateTextRect:CGRect!
//    var dicDetail :NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("转出详情", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn

        self.kindAvatar.layer.cornerRadius = 45/2
        self.kindAvatar.layer.masksToBounds = true
        self.kindAvatar.layer.borderColor = UIColor.white.cgColor
        self.kindAvatar.layer.borderWidth = 1.0;
        
        self.toavatar.layer.cornerRadius = 50/2
        self.toavatar.layer.masksToBounds = true
        self.toavatar.layer.borderColor = UIColor.white.cgColor
        self.toavatar.layer.borderWidth = 1.0;

        
        self.out2VM.getInfoSignal()
        self.kindlist.delegate = out2VM
        self.kindlist.dataSource = out2VM
        self.kindlist.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.avatar.layer.cornerRadius = 50/2
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 1.0;
        self.avatar.setImageWith(NSURL(string: UserDefaults.standard.object(forKey: "avatar")as!String)! as URL, placeholderImage: UIImage(named: "缺省头像"))
        
        let avatar = UserDefaults.standard.object(forKey: "avatar")
        if avatar != nil {
             self.avatar.setImageWith(NSURL(string: avatar as! String)! as URL, placeholderImage: UIImage(named: "缺省头像"))
        }else{
             self.avatar.image =  UIImage(named: "缺省头像")
        }
        
        self.out2VM.target = self
        self.name.text =  UserDefaults.standard.object(forKey: "name")! as? String
//        self.after.text = String (format: "可用余额:%.3f", UserDefaults.standard.object(forKey: "balance") as! Double)
    }
   
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func selectBut(){
       self.out2VM.walletlistSignal()
    }
    @IBAction func nextBut(){
        self.out2VM.nextStepSignal()
    }
    @IBAction func cancelBut(){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var tableHeight: NSLayoutConstraint!
    
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

extension OutDetail2ViewController:UITextFieldDelegate,UITextViewDelegate{
    
    
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

