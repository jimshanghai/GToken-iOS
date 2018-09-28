//
//  constant.swift
//  Swift3Test
//
//  Created by Miaoz on 16/12/27.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

import Foundation

import UIKit




let kScreenWidth:CGFloat    = UIScreen.main.bounds.width
let kScreenHeight:CGFloat   = UIScreen.main.bounds.height
let kStatusBarheight = UIApplication.shared.statusBarFrame.size.height
let kNavBarHeight_StatusHeight: ((UIViewController)-> CGFloat) = {(vc : UIViewController ) -> CGFloat in
    weak var weakVC = vc;
    var navHeight = weakVC?.navigationController?.navigationBar.bounds.size.height ?? 0.0
    return (navHeight + kStatusBarheight)
}
let TheUserDefaults         = UserDefaults.standard
let kDeviceVersion          = Float(UIDevice.current.systemVersion)
let kTabBarHeight:CGFloat   = 49
let kOrangeColor     = UIColor(red: 249.0/255.0, green: 155.0/255.0, blue: 72.0/255.0, alpha: 1.0)

let kBackGroundColor     = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
let kCutDwonGroundColor     = UIColor(red: 90.0/255.0, green: 134.0/255.0, blue: 244.0/255.0, alpha: 1.0)
let sectionColor = RGBA(r: 0.94, g: 0.94, b: 0.96, a: 1.00)
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r, green: g, blue: b, alpha: a)
}
let address = "https://wallet.edc.org.cn"
let API_login  = address + "/api/login"
let API_sms  = address + "/api/smscodes"
let API_email  = address + "/api/sendEmail"
let API_regist  = address + "/api/register"
let API_keystoreregist  = address + "/api/bindRegister"
let API_walletlist  = address + "/api/walletList"
let API_transactionslist  = address + "/api/transactions_list"
let API_userContactlist  = address + "/api/getUserContact"
let API_userRecentContactlist  = address + "/api/getUserLately"
let API_totransfer  = address + "/api/userTransferAccounts"
let API_addcontact  = address + "/api/addtUserContact"
let API_istransfer  = address + "/api/isTransferAccounts"
let API_resetPassword  = address + "/api/resetPassword"
let API_getInfo  = address + "/api/getUserInfo"
let API_getuserInfo  = address + "/api/userInfo"
let API_saveInfo  = address + "/api/updateUser"
let API_qiniutoken  = address +  "/qiniutoken"
let API_deletContact  = address +  "/api/deltUserContact"
let API_findUrl  = address +  "/api/find"
let API_isExistKeyStore = address + "/api/isKeyStore"
let API_keystorelogin  = address + "/api/keysotreLogin"
let API_keystoreupdatePassword  = address +  "/api/updateKeystorePsd"// /
let API_keystoreset = address +  "/api/newSetKeystore"
let API_laguage = address + "/api/changeLanguage"
