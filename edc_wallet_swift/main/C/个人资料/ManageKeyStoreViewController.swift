//
//  ManageKeyStoreViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/16.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class ManageKeyStoreViewController: UIViewController {

    
    
    @IBAction func downloadButton(_ sender:Any){
        //下载keystore  展示keystore 
        self.navigationController?.pushViewController(DownloadSuccessViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("下载Keystore", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //返回按钮点击响应
    @objc func backToPrevious(){
      self.navigationController?.popViewController(animated: true)
    }

}
