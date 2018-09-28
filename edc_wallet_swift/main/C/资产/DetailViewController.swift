//
//  DetailViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import MJRefresh
class DetailViewController: UIViewController {
    var slewalletlistmodel:WalletlistModel! 
    
    let detailVM:DetailViewModel = DetailViewModel()
    let search =  SearchViewController()
//    @IBOutlet var  table:UITableView!
    @IBOutlet var yuE: UILabel!
    @IBOutlet var  after:UILabel!
    @IBOutlet var  avatar:UIImageView!
    @IBOutlet var  bg:UIImageView!
     @IBOutlet var outBut:UIButton!
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var barframe:CGRect = CGRect.zero
 
    @IBAction func outButton(_ sender: Any){
      let  out = OutDetailViewController()
      out.selectwalletlistmodel = self.slewalletlistmodel
      out.outVM.contract_id = detailVM.contract_id
      out.banlance = self.detailVM.banlance
      self.navigationController?.pushViewController(out, animated: true)
    }
    @IBAction func inButton(_ sender: Any){
        self.navigationController?.pushViewController(MyQRCodeViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(format: "%@交易详情", self.slewalletlistmodel.zh_name)
        self.yuE.text =  String(format: "%@余额", self.slewalletlistmodel.symbol)
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
       
        self .addChildViewController(search)
        print(outBut.frame.minY,bg.frame.maxY)
        let tableViewFrame = CGRect(x: 0, y:bg.frame.height + kNavBarHeight_StatusHeight(self), width: kScreenWidth, height:outBut.frame.minY - bg.frame.maxY + kNavBarHeight_StatusHeight(self)+kStatusBarheight)
        search.tableView.frame = tableViewFrame
        self.view .addSubview(search.view)
        search.didMove(toParentViewController: self)
       
        // Do any additional setup after loading the view.
        search.tableView.register(UINib(nibName:"DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
//        search.schoolArray = self.detailVM.transationslistarray
        self.avatar.layer.cornerRadius = 59/2
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 1.0;
        self.avatar.setImageWith(NSURL(string:self.slewalletlistmodel.icon)! as URL, placeholderImage: UIImage(named: "缺省头像"))
        self.detailVM.target = self
        search.tableView.delegate = detailVM
        search.tableView.dataSource = detailVM
        search.countrySearchController.searchResultsUpdater = detailVM
        self.after.text = String(format: "%.3f",  self.detailVM.banlance)
        search.tableView.isHidden = self.detailVM.transationslistarray.count == 0 ? true : false
        // 顶部刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("松开刷新...", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        search.tableView.mj_header = header
        // 底部刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        search.tableView.mj_footer = footer
    }
    // 顶部刷新
    @objc fileprivate func headerRefresh(){
        print("下拉刷新")
        search.tableView.mj_header.endRefreshing()
    }
    // 底部刷新
    @objc fileprivate func footerRefresh(){
        print("上拉刷新")
        
    }
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      print(outBut.frame.minY,bg.frame.maxY)
      let tableViewFrame = CGRect(x: 0, y:bg.frame.height, width: kScreenWidth, height:outBut.frame.minY - bg.frame.maxY)
     search.tableView.frame = tableViewFrame
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if (self.navigationController?.viewControllers.count > 1) {
            self.tabBarController?.tabBar.isHidden = true
        }else {
            self.tabBarController?.tabBar.isHidden = false
        }
        barframe  =   (self.tabBarController?.tabBar.frame)!
        self.tabBarController?.tabBar.frame = CGRect.zero
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.frame = barframe
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

