//
//  MainTabbarViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/10.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    class func CustomTabBar()->UITabBarController {
        let viewControllerArray = [HomeViewController(),FindViewController(),OwnViewController()]
        let tabBarVC = MainTabbarViewController()
        
        let tabbarArray = ["zc","fx","w"]
        let titleArray = ["","",""]
//        let  navTitle = ["GToken钱包","发现","我的"]
        var index:Int = 0
        //循环像tabbarcontroller中添加对应的子控制器
        for str in viewControllerArray{
            //创建导航控制器
            let nav : UINavigationController = UINavigationController.init(rootViewController: str)
            tabBarVC.addChildViewController(nav)
            //设置对应的tabbaritem
            let normalStr:String = tabbarArray[index]
            let title:String = titleArray[index]
            let selectStr:String = normalStr+"Select"
          
            nav.tabBarItem = UITabBarItem(title: title, image: UIImage(named: normalStr), selectedImage:  UIImage(named: selectStr))
            nav.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(red: 165.0/255.0, green: 166.0/255.0, blue: 167.0/255.0, alpha: 1)], for: UIControlState.normal)//  RGBA(165, 166, 167, 1)
            nav.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(red: 93.0/255.0, green: 137.0/255.0, blue: 245.0/255.0, alpha: 1)], for: UIControlState.selected)//  RGBA(93, 137, 245, 1)
            index += 1
        }
        //设置tabbar的背景
        tabBarVC.tabBar.isTranslucent=false
        tabBarVC.tabBar.barStyle = .default

        
//        tabBarVC.tabBar.barTintColor = UIColor(patternImage: UIImage(named: "Main_tabBar_background")!)
//        tabBarVC.tabBar.backgroundImage = UIImage(named: "Main_tabBar_background")
        return tabBarVC
        
    }


}
