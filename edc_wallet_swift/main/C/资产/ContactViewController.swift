//
//  ContactViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
//声明一个protocal，必须继承NSObjectProtocal
protocol seletcontact:NSObjectProtocol{
    func seletcontactwithNumber(numbers:String)
}
class ContactViewController: UIViewController {
    var isPush:Bool  = false
    var  isPersonal :Bool = false//个人资料
    var segmentedControl:UISegmentedControl!
    weak var delegate:seletcontact!
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    var  Contractlistarray:NSArray!
    @IBOutlet  var table:UITableView!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isPush = false;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isPush == false {//pop
           
        }
         self.table.mj_header.beginRefreshing()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPersonal != true{
           isPush = true
        }
        
        // Do any additional setup after loading the view.
        title = NSLocalizedString("联系人", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        let rightBarBtn = UIBarButtonItem(title: " ", style: .plain, target: self,  action: #selector(addContacts))
        rightBarBtn.image = UIImage(named: "增加")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        self.table.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        if self.Contractlistarray != nil {
            if self.Contractlistarray.count == 0 {
                self.table.isHidden = true
            }else{
                self.table.isHidden = false
            }
        }

        //分段选项显示
        let items = ["最近联系人","联系人"] as [Any]
        //初始化对象
        segmentedControl = UISegmentedControl(items:items)
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 0, height:38)
        //设置位置
        segmentedControl.center = self.view.center
        
        //当前选中下标
        segmentedControl.selectedSegmentIndex = 0
        
        //添加事件
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: UIControlEvents.valueChanged)
        self.table.tableHeaderView =  segmentedControl
        
        // 顶部刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("松开刷新...", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        self.table.mj_header = header
    }
    //选择点击后的事件
    @objc func segmentedControlChanged(sender:UISegmentedControl) {
        contractsSignal(index: sender.selectedSegmentIndex)
    }
    // 顶部刷新
    @objc fileprivate func headerRefresh(){
        print(NSLocalizedString("下拉刷新", comment: ""))
        
        self.table.mj_header.endRefreshing()
        contractsSignal(index:segmentedControl.selectedSegmentIndex )
    }
    func contractsSignal(index:Int) {
        var url:String!
        if(index == 0){
            url = API_userRecentContactlist
        }else{
            url = API_userContactlist
        }
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: url, params: nil , success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as?Int == 200 ){
                
                let list:NSMutableArray = NSMutableArray()
                let array = result["data"] as!NSArray
                for dic in array {
                    let model = try? LsqDecoder.decode(ContractModel.self, param: dic as! [String : Any])
                    list.add(model as Any)
                }
                self.Contractlistarray = list.copy() as! NSArray
                self.table.reloadData()
                if(self.Contractlistarray.count == 0 ){
                    self.table.isHidden = true
                }else{
                     self.table.isHidden = false
                }
                
            }
            else {
                self.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            
        }
        
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    @objc func addContacts(){
      let add = AddContactViewController()
      self.navigationController?.pushViewController(add, animated: true)
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

extension  ContactViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Contractlistarray == nil {
            return 0
        }
        return self.Contractlistarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "ContactCell") as? ContactCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        if self.Contractlistarray != nil {
          let model = Contractlistarray.object(at: indexPath.row) as! ContractModel
            if model.avatar != nil{
                cell?.icon.setImageWith(NSURL(string: model.avatar)! as URL, placeholderImage: UIImage(named: "缺省头像"))
            }else{
                cell?.icon.image = UIImage(named:"缺省头像")
            }
            cell?.name.text = model.username
            
            cell?.numbers.text =  String(format: "账号:%@", model.numbers)
            
        }
       
       return cell!
    }
    //允许编辑cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //右滑触发删除按钮
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return UITableViewCellEditingStyle.delete
        
    }
    //点击删除cell时触发
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("indexPath.row = editingStyle第\(indexPath.row)行")
        if editingStyle == UITableViewCellEditingStyle.delete {
            let  array = NSMutableArray(array: self.Contractlistarray)
            let model = self.Contractlistarray.object(at: indexPath.row) as! ContractModel
            array.removeObject(at: indexPath.row)
            self.Contractlistarray = array.copy()as! NSArray
            tableView.setEditing(false, animated: true)
            delecontractsSignal(dic: ["numbers":model.numbers])
            
            
        }
        tableView.reloadData()
    }
    func delecontractsSignal(dic:NSDictionary) {
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_deletContact, params: dic as? [String : AnyObject], success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as?Int == 200 ){
                 self.alertWithClick(msg: NSLocalizedString("删除成功", comment: ""))
            }
            else {
                self.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.alertWithClick(msg: "哎呀,出了点问题,刷新试一下")
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isPersonal == false{
            let model = Contractlistarray.object(at: indexPath.row) as! ContractModel
            self.delegate.seletcontactwithNumber(numbers: String(format: "%@", model.numbers))
            self.navigationController?.popViewController(animated: true)
        }
        
       
    }
}
