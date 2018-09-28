//
//  KLoginPrivateViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/3.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class KLoginPrivateViewController: UIViewController {
 let keystoreLoginVM:KeystoreLoginViewModel = KeystoreLoginViewModel()
    @IBOutlet var keystorepawd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
          keystoreLoginVM.target = self
        // Do any additional setup after loading the view.
        keystorepawd.superview?.layer.borderColor = UIColor.lightGray.cgColor
        keystorepawd.superview?.layer.borderWidth = 1.0
    }
    @IBAction func keystoreLoginAction(_ sender: Any) {
            if self.keystorepawd.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("请输入keystore密码", comment: ""))
                return
            }
    
        self.keystoreLoginVM.keyStoreLogin(dic: ["keystore":    UserDefaults.standard.object(forKey: "keystorejson") as! String,"password":self.keystorepawd.text as Any])
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
