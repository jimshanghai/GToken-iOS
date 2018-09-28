//
//  SuccessViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/21.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        title = NSLocalizedString("交易结果", comment: "")
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
    }
    @IBAction func okAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
