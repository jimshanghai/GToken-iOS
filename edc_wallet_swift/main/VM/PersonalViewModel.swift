//
//  PersonalViewModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/21.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import SVProgressHUD

class PersonalViewModel: NSObject {
   weak var target:PersonalViewController!
   var AvatarUrl :String!
    
    func getQiniuSignal(image:UIImage){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在上传图片", comment: ""))
        NetworkTools.shareInstance.request(methodType: .GET, urlString: API_qiniutoken, params:nil, success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                return
            }
            let result = obj as!NSDictionary
            if((result.object(forKey: "uptoken")) != nil){
               
                let data:NSData  =  self.resetImgSize(sourceImage: image, maxImageLenght: 200.0, maxSizeKB: 200.0) as NSData
                //缺少命名空间  还有key
                QiniuTool.sharedInstance.controller = self.target
                let key = String(format: "user/avatar/%@/Anna_Key%@.jpg", UserDefaults.standard.object(forKey: "numbers")as!String,self.getCurrentTime())
                
                QiniuTool.sharedInstance.uploadImageData(image: data as Data, key: key, token: result.object(forKey: "uptoken")as! String, result: { (_ progress: Float? , _ imageKey:String?) in
    
                    if(imageKey != nil){
                        self.AvatarUrl = String(format: "https://resource.edc.org.cn/%@?imageView2/1/w/200/h/200",imageKey!)
                        self.target.avatar.image = image
                      
                    }
 //                       else{
//                        if(progress == 1.0){
//                            Tool.confirm(title: "温馨提示", message: "上传失败,再试试!", controller: self.target)
//
//                        }

//                    }
                })
                
            }
            else {
                self.target.alertWithClick(msg: result.object(forKey: "msg")as! String)
            }

        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
        }
    }
    func getCurrentTime() -> String{
        
        let date = NSDate.init(timeIntervalSinceNow: 0)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMddhhmmss"
        let str = "\(dateformatter.string(from: date as Date))"
        return str
    }
    ///图片压缩方法
    
    func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        
        var maxSize = maxSizeKB
        
        var maxImageSize = maxImageLenght
        
        
        
        if (maxSize <= 0.0) {
            
            maxSize = 1024.0;
            
        }
        
        if (maxImageSize <= 0.0)  {
            
            maxImageSize = 1024.0;
            
        }
        
        //先调整分辨率
        
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        
        let tempHeight = newSize.height / maxImageSize;
        
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
            
        }
            
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
            
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
        
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        
        //调整大小
        
        var resizeRate = 0.9;
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
            
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            
            resizeRate -= 0.1;
            
        }
        
        return imageData!
        
    }
    
    func saveInfoSignal(dic:NSDictionary){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在保存", comment: ""))
        let tokenValue = UserDefaults.standard.object(forKey: "access_token")as!String
        NetworkTools.shareInstance.requestSerializer.setValue("Bearer "+tokenValue, forHTTPHeaderField: "Authorization")
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_saveInfo, params: dic as? [String : AnyObject], success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{

                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
               self.target.navigationController!.popViewController(animated: true)
               UserDefaults.standard.set(dic["avatar"], forKey: "avatar")
               UserDefaults.standard.set(dic["name"], forKey: "name")
                if(dic["mobile"] != nil ){
                     UserDefaults.standard.set(dic["mobile"], forKey: "mobile")
                }
               let notificationName = Notification.Name(rawValue: "avatar_update")
//               NotificationCenter.post(name: notificationName.rawValue, object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName.rawValue), object: nil, userInfo: nil)
            }
            else {
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String))
            }

        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")

        }

    }
    func getInfoSignal(){
        SVProgressHUD.show(withStatus: NSLocalizedString("正在加载", comment: ""))
        NetworkTools.shareInstance.request(methodType: .POST, urlString: API_getuserInfo, params: ["numbers":UserDefaults.standard.object(forKey: "numbers")as!String as AnyObject], success: { (obj) in
            SVProgressHUD.dismiss()
            guard (obj as? [String : AnyObject]) != nil else{
                
                return
            }
            let result = obj as!NSDictionary
            if(result.object(forKey: "code")as? Int == 200 ){
                    if((result.object(forKey: "data") as!NSDictionary)["email"] != nil && !((result.object(forKey: "data") as!NSDictionary)["email"]  is  NSNull)){
                    UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["email"], forKey: "email")
                    self.target.email.text = (result["data"] as! NSDictionary) ["email"] as? String
                }
                 if((result.object(forKey: "data") as!NSDictionary)["mobile"] != nil && !((result.object(forKey: "data") as!NSDictionary)["mobile"]  is  NSNull)){
                    UserDefaults.standard.set((result.object(forKey: "data")as!NSDictionary)["mobile"], forKey: "mobile")
                    self.target.mobile.text = (result["data"] as! NSDictionary) ["mobile"] as? String
                }
                self.target.name.text = (result["data"] as! NSDictionary) ["name"] as? String
                self.AvatarUrl = (result["data"] as! NSDictionary) ["avatar"] as? String
            }
            else {
                self.target.alertWithClick(msg: (result.object(forKey: "msg")as! String))
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            self.target.alertWithClick(msg: "哎呀,出了点问题,重新试一下")
            
        }
        
    }
}
