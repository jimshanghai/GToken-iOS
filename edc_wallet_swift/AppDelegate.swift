//
//  AppDelegate.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/7.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import AFNetworking
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func getCurrentLanguage() -> String {
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return "en"//英文
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "zh"//中文
        default:
            return "en"
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NetworkTools.shareInstance.request(methodType: .GET, urlString:"https://wallet.edc.org.cn/api/versions/1",  params:nil , success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                 let  versionStr =  result.object(forKey: "data") as? String
                    if (UserDefaults.standard.object(forKey: "app_version") != nil) {
                        if   (UserDefaults.standard.object(forKey: "app_version") as! String) == versionStr {
                              self.loginOrMain()
                        }else{
                             self.alertWithClick(msg: "请检查更新版本")
                        }
                    }else{
                        UserDefaults.standard.set(versionStr, forKey: "app_version")
                         self.loginOrMain()
                }
            }
        }) { (error) in
            
        }
        
         networkStatusListener()
        let dic:NSDictionary = ["type":getCurrentLanguage()]
        NetworkTools.shareInstance.request(methodType: .GET, urlString: API_laguage, params: dic as? [String : AnyObject], success: { (obj) in
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
            }
        }) { (error) in
            
        }
        
       
        return true
    }
    
    //检测是否登录
    func loginOrMain() {
        if (UserDefaults.standard.object(forKey: "access_token") != nil) {
            if (UserDefaults.standard.object(forKey: "access_token") as! String == "loginout") {
                gotoLogin()
            }else{
               gotoMainvc()
            }
        }else{
            gotoLogin()
        }
    }
    func gotoLogin() {
        let loginvc = LoginViewController();
        let nav = UINavigationController.init(rootViewController: loginvc)
        self.window?.rootViewController = nav
    }
    func gotoMainvc() {
        let main = MainTabbarViewController.CustomTabBar();
//        let nav = UINavigationController.init(rootViewController: main)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = main
    }
    func networkStatusListener() {
        
        
        // 1、设置网络状态消息监听
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.networkStatusChange), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object:nil)//Swift
        
        // 2、获得网络Reachability对象
        
        // Reachability必须一直存在，所以需要设置为全局变量
        
        // 3、开启网络状态消息监听
        
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
   @objc func networkStatusChange() {
        if AFNetworkReachabilityManager.shared().isReachable {// 判断网络连接状态
        }else{
          alertWithClick(msg: NSLocalizedString("请检查您的网路", comment: ""))
            
        }
        
    }
    
    func alertWithClick(msg:String!) -> Void {
        let alertController = UIAlertController(title: NSLocalizedString("温馨提示", comment: ""),
                                                message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
//    if (url != nil) {
//    NSString *path = [url absoluteString];
//    NSMutableString *string = [[NSMutableString alloc] initWithString:path];
//    if ([path hasPrefix:@"file://"]) {
//    [string replaceOccurrencesOfString:@"file://" withString:@"" options:NSCaseInsensitiveSearch  range:NSMakeRange(0, path.length)];
//    }
//    [self.viewController openPng:string];
//
//    }
//
//    return YES;
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        if (url != nil) {
//            let path =  url.absoluteString
//            var string = NSMutableString.init(string: path)
//            if(path.hasPrefix("file://")){
//                string.replaceOccurrences(of: "file://", with: "", options: , range: NSMakeRange(0, path))
//            }
        
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

