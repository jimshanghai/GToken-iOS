//
//  CityListViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/14.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

//声明一个protocal，必须继承NSObjectProtocal
protocol ChangeCity:NSObjectProtocol{
    func ChangeCityWithCityName(cityName:String)
}


class CityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var currentCityLabel:UILabel?
    var tableView:UITableView?
    var cities:NSDictionary?
    var keys:[String]?
    weak var delegate:ChangeCity?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("选择地区", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn

        //        if self.locationManager.responds(to: #selector("requestAlwaysAuthorization")) {
        //            print("requestAlwaysAuthorization")
        //            if #available(iOS 8.0, *) {
        //                self.locationManager.requestAlwaysAuthorization()
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        }

        loaddata()
        initUI()
        
    }
    
    
    
    func loaddata() {
        let path:String = Bundle.main.path(forResource: "areascode", ofType: "plist")!
        cities = NSDictionary(contentsOfFile: path)
        
        let allkays = cities!.allKeys as NSArray
        let sortedStates = allkays.sortedArray(using: #selector(NSNumber.compare(_:)))
        let sortingArray = NSMutableArray.init(array: sortedStates)
        sortingArray.removeLastObject()
        sortingArray.insert(NSLocalizedString("热门", comment: ""), at: 0)
        keys = sortingArray as? Array<String>
    }
    
    private func initUI() {
        let headerLabel = UILabel(frame:  CGRect(x: 0, y: kNavBarHeight_StatusHeight(self), width: kScreenWidth, height: 0))
        headerLabel.backgroundColor = kBackGroundColor
        view.addSubview(headerLabel)
        
        currentCityLabel = UILabel(frame:  CGRect(x: headerLabel.frame.origin.x, y: headerLabel.frame.origin.y+headerLabel.frame.size.height, width: headerLabel.frame.size.width, height: headerLabel.frame.size.height+10))
        currentCityLabel!.backgroundColor = UIColor.white
        currentCityLabel?.textColor = UIColor.orange
        currentCityLabel?.isUserInteractionEnabled = true
        view.addSubview(currentCityLabel!)
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(tapToChangeCity(sender:)))
        currentCityLabel?.addGestureRecognizer(tap)
        
        tableView = UITableView(frame: CGRect(x: (currentCityLabel?.frame.origin.x)!, y: (currentCityLabel?.frame.origin.y)!+(currentCityLabel?.frame.size.height)!, width: (currentCityLabel?.frame.size.width)!, height: (kScreenHeight-(currentCityLabel?.frame.size.height)!)-headerLabel.frame.size.height-kNavBarHeight_StatusHeight(self)), style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
        self.view.addSubview(tableView!)
        
    }
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    @objc func tapToChangeCity(sender:UITapGestureRecognizer){
        if((currentCityLabel?.text?.isEmpty) == nil){
            return
        }
        let city:String = ((currentCityLabel?.text)! as NSString).substring(from: 4)
        delegate?.ChangeCityWithCityName(cityName: city)
        navigationController?.popViewController(animated: true)
        
    }
    
    //UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return (keys?.count)!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let keys_:NSArray = NSArray(array: keys!);
        let key = keys_.object(at: section)
        
        let temp:NSArray = (cities?.object(forKey: key))! as! NSArray
        return temp.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
   
        let cell = tableView .dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath ) as! CityTableViewCell
       
        let keysTemp:NSArray = NSArray(array: keys!);
        
        let key = keysTemp.object(at: indexPath.section)
        
        let temp:NSArray = (cities?.object(forKey: key))! as! NSArray
        let tempDic:NSDictionary = (temp.object(at: indexPath.row) as? NSDictionary)!
        let  string:NSString = " +" + (tempDic.object(forKey: "code") as? String)! as NSString
        cell.code.text = string as String
        cell.country.text = tempDic.object(forKey: "country") as? String

        return cell
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        
        
        headerLabel.backgroundColor = kBackGroundColor
        let keys_:NSArray = NSArray(array: keys!);
        
        let key = keys_.object(at: section)
        let textString = "    "+(key as? String)!;
        headerLabel.text = textString
        return headerLabel
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let  cell =  tableView.cellForRow(at: indexPath) as! CityTableViewCell
//        NSLog("%@", cell.code.text ?? 00 )
//        let keysTemp:NSArray = NSArray(array: keys!);
//
//        let key = keysTemp.object(at: indexPath.section)
//
//        let temp:NSArray = (cities?.object(forKey: key))! as! NSArray
        
        self.delegate?.ChangeCityWithCityName(cityName: (cell.code.text)!)
        navigationController?.popViewController(animated: true)
        
    }

}
