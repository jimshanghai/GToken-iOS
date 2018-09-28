//
//  BindViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/7.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class BindViewController: UIViewController {
   let bindVM:BindViewModel = BindViewModel()
    @IBOutlet var address: UILabel!
    @IBOutlet var nameTf: UITextField!
    
    var addressStr: String!
    @IBAction func regitsterAction(_ sender: Any) {
        
        if nameTf.text?.lengthOfBytes(using: .utf8) == 0 {
            alertWithClick(msg: NSLocalizedString("请输入姓名", comment: ""))
            return
        }
        self.bindVM.regitser(dic:["name": nameTf.text ?? "","keystore": UserDefaults.standard.object(forKey: "keystorejson")!])
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("绑定用户", comment: "")
        self.address.text = "您的Token地址:\n" + addressStr
        self.edgesForExtendedLayout = []
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.darkText,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        self.bindVM.target = self
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        nameTf.superview?.layer.borderColor = UIColor.lightGray.cgColor
        nameTf.superview?.layer.borderWidth = 1.0
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
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
