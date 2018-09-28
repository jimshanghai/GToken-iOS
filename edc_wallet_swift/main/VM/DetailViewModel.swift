//
//  DetailViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/20.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class DetailViewModel: NSObject,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating {
  
    
   var transationslistarray:NSArray!
    //搜索过滤后的结果集
    var result:NSArray = NSArray(){
        didSet  {self.target.search.tableView.reloadData()}
    }
   var banlance:Double!
   var contract_id:String!
   weak var target:DetailViewController!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.transationslistarray == nil {
            return 0
        }
        if self.target.search.countrySearchController.isActive {
           return self.result.count
        }else{
           return self.transationslistarray.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "DetailCell") as? DetailCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        var model:TransationModel!
        if self.target.search.countrySearchController.isActive {
            model = (self.result.object(at: indexPath.row) as! TransationModel)
        }else{
            model = (transationslistarray.object(at: indexPath.row) as! TransationModel)
        }
        if model.avatar != nil{
            if(model.avatar.hasPrefix("/uploads")){
                cell?.avatar.setImageWith(NSURL(string:"https://edc.org.cn" +  model.avatar)! as URL, placeholderImage: UIImage(named: "缺省头像"))
            }else{
                cell?.avatar.setImageWith(NSURL(string: model.avatar)! as URL, placeholderImage: UIImage(named: "缺省头像"))
            }
          
        }else{
          cell?.avatar.image = UIImage(named:"缺省头像")
        }
        if(model.txhash != nil){
           cell?.txHash.text = "TxHash:" + model.txhash
        }else{
             cell?.txHash.text = "TxHash:"
        }
       
        cell?.name.text = model.name
        cell?.number.text =  model.numbers == nil ? NSLocalizedString("--", comment: "") :  String(format: "No.%@", model.numbers)
        cell?.ceated_at.text = model.created_at
        if model.used_type == "1" {
          cell?.transation.text = String(format: "-%@", model.used)
        }else{
          cell?.transation.text = String(format: "+%@", model.used)
        }
        if model.state == "1"{
          cell?.stateLable.isHidden = true
          
        }
        if model.state == "2"{
          cell?.stateLable.isHidden = false
            cell?.stateLable.text = NSLocalizedString("确认", comment: "")
        }
        if model.state == "5"{
          cell?.stateLable.isHidden = false
        cell?.stateLable.text = NSLocalizedString("待提交", comment: "")
        }
        if model.state == "10"{
          cell?.stateLable.isHidden = false
          cell?.stateLable.text = NSLocalizedString("失败", comment: "")
        }
        cell?.after.text = String(format: "%@", model.after)
        if(model.remarks != nil &&  model.remarks.lengthOfBytes(using:.utf8) > 50){
            model.remarks = String( model.remarks.prefix(50))
        }
        cell?.mark.text = model.remarks == nil ? NSLocalizedString("---- ", comment: "") : model.remarks
        return cell!
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.result = transationslistarray.filter({ (item) -> Bool in
            return (item as! TransationModel).name.contains(searchController.searchBar.text!)
        }) as NSArray
    }
    
}
