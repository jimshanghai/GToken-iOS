//
//  NameViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/1.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
//声明一个protocal，必须继承NSObjectProtocal
protocol nameChange:NSObjectProtocol{
    func namechangeWithName(name:String )
}

class NameViewController: UIViewController {
    weak var delegate:nameChange!
    @IBOutlet var name: UITextField!
    var nameStr:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("设置姓名", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        self.name.text = self.nameStr
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        if  (UserDefaults.standard.object(forKey: "name") as! String != self.name.text!){
            if name.text?.lengthOfBytes(using: .utf8) == 0 {
                alertWithClick(msg: NSLocalizedString("姓名不能为空", comment: ""))
                return
            }
            self.delegate.namechangeWithName(name: name.text!)
        }
        self.navigationController?.popViewController(animated: true)
        
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
