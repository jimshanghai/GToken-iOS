//
//  DownloadSuccessViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/2.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class DownloadSuccessViewController: UIViewController {

    @IBOutlet var keystoreLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("下载keystore", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.keystoreLable.text  = (UserDefaults.standard.object(forKey: "keystorejson") as! String)
        // Do any additional setup after loading the view.
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = keystoreLable.text
        let alertController = UIAlertController(title: "复制成功!",
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
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
