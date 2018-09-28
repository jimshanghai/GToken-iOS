//
//  SearchViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
class SearchViewController: UITableViewController {

    //展示列表
//    var tableViews: UITableView!
    
    //搜索控制器
    var countrySearchController = UISearchController()
    
//    //原始数据集
//    var schoolArray = ["清华大学","北京大学","中国人民大学","北京交通大学","北京工业大学",
//                       "北京航空航天大学","北京理工大学","北京科技大学","中国政法大学",
//                       "中央财经大学","华北电力大学","北京体育大学","上海外国语大学","复旦大学",
//                       "华东师范大学","上海大学","河北工业大学"]
//
//    //搜索过滤后的结果集
//    var searchArray:[String] = [String](){
//
//        didSet  {self.tableView.reloadData()}
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //创建表视图
//        let tableViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width,height: self.view.frame.height)
//        self.tableView = UITableView(frame: tableViewFrame, style:.plain)
//        self.tableView!.delegate = self
//        self.tableView!.dataSource = self
        //创建一个重用的单元格
//        self.tableView!.register(UITableViewCell.self,forCellReuseIdentifier: "MyCell1")
        //配置搜索控制器
    self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
//            controller.searchResultsUpdater = self    //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.tableView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.tableView.isHidden = false
//
//        //创建表视图
//        let tableViewFrame = CGRect(x: 0, y: 300, width: self.view.frame.width,
//                                    height: self.view.frame.height-200)
//        self.tableView.frame = tableViewFrame
//        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//extension SearchViewController {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.countrySearchController.isActive {
//            return self.searchArray.count
//        } else {
//            return self.schoolArray.count
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
//        -> UITableViewCell {
//            //为了提供表格显示性能，已创建完成的单元需重复使用
//            let identify:String = "MyCell1"
//            //同一形式的单元格重复使用，在声明时已注册
//            let cell = tableView.dequeueReusableCell(withIdentifier: identify,
//                                                     for: indexPath)
//
//            if self.countrySearchController.isActive {
//                cell.textLabel?.text = self.searchArray[indexPath.row]
//                return cell
//            } else {
//                cell.textLabel?.text = self.schoolArray[indexPath.row]
//                return cell
//            }
//    }
//}

//extension SearchViewController{
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
//extension SearchViewController: UISearchResultsUpdating
//{
//    //实时进行搜索
//    func updateSearchResults(for searchController: UISearchController) {
//
//        self.searchArray = self.schoolArray.filter { (school) -> Bool in
//            return school.contains(searchController.searchBar.text!)
//        }
//    }
//}
