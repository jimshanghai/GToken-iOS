//
//  HomeViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/7.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import MJRefresh

class HomeViewController: UIViewController{
   let homeVM:HomeViewModel = HomeViewModel()
    // 顶部刷新
  let header = MJRefreshNormalHeader()
     @IBOutlet var table: UITableView!
    
     @IBOutlet var avatar: UIImageView!
     @IBOutlet var name: UILabel!
     @IBOutlet var number: UILabel!
     @IBOutlet var qrcode: UIButton!
    
    @IBAction func longPressAccount(_ sender: Any) {
        UIPasteboard.general.string = number.text
        let alertController = UIAlertController(title: "复制成功!",
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("Gongga钱包", comment: "")
      
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
             self.edgesForExtendedLayout = []
//        }
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.darkText,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        self.table.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.avatar.layer.cornerRadius = 59/2
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 1.0;
        
        self.table.delegate = homeVM
        self.table.dataSource = homeVM
        self.homeVM.target = self;
        
        
        let rightBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(scanAction))
        rightBarBtn.image = UIImage(named: "扫一扫 灰")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        table.separatorStyle = UITableViewCellSeparatorStyle.none;
        // 顶部刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("松开刷新...", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        table.mj_header = header
        qrcode.addTarget(self, action: #selector(qrcodeAction), for: UIControlEvents.touchUpInside)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(update_avatar),
                                               name:  Notification.Name(rawValue: "avatar_update"), object: nil)
        if( UserDefaults.standard.object(forKey: "needInfoAlert") != nil ){
            if( UserDefaults.standard.object(forKey: "needInfoAlert")as! Bool == true){
                alertWithClick(msg: "建议先到个人信息页补充个人信息")
                UserDefaults.standard.set(false, forKey: "needInfoAlert")
            }
        }
    }
    // 顶部刷新
    @objc fileprivate func headerRefresh(){
        print("下拉刷新")
        self.homeVM.walletlistSignal()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
          table.mj_header.beginRefreshing()
        
    }
    @objc  func  qrcodeAction(){
        self.navigationController?.pushViewController(MyQRCodeViewController(), animated: true)
    }
    @objc  func  scanAction(){
    let scan = ScanViewController()
    self.navigationController?.pushViewController(scan, animated: true)
    }
    @objc func update_avatar() -> Void {
        self.avatar.setImageWith(NSURL(string: UserDefaults.standard.object(forKey: "avatar")as!String)! as URL, placeholderImage: UIImage(named: "缺省头像"))
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

