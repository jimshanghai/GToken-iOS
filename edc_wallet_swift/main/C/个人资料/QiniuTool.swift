//
//  QiniuTool.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/24.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import Qiniu

class QiniuTool: NSObject {
       weak var controller:PersonalViewController!
        static let sharedInstance = QiniuTool()
        var Index : Int = 0
        func uploadImageData(image:Data ,  key:String ,token:String ,result: @escaping (_ progress: Float? , _ imageKey:String? ) -> ()) {

            let opt = QNUploadOption(mime: "image/jpeg", progressHandler: {(key, progres) in
                
                result(progres, nil)
            }, params: ["x:width":"200", "x:height":"200","x:type":"image"], checkCrc: true, cancellationSignal: nil)
            
            var cutdownData : Data!
            if (image.count < 9999) {
                cutdownData = image
            } else if (image.count < 99999) {
                let nowImage = UIImage.init(data: image)!
                cutdownData = UIImageJPEGRepresentation(nowImage, 0.6)
            } else {
                let nowImage = UIImage.init(data: image)!
                cutdownData = UIImageJPEGRepresentation(nowImage, 0.3)
            }
            
            if let manager = QNUploadManager() {
                manager.put(cutdownData, key: key, token: token, complete: { (Info, key, resp) in
                    if (Info?.isConnectionBroken)! {
                        Tool.confirm(title: NSLocalizedString("温馨提示", comment: ""), message: NSLocalizedString("网络连接错误", comment: ""), controller: self.controller)
                        return
                    }
                    
                    if let imageKey = resp?["key"] as? String {
                        result(nil, imageKey)
                    }
                    
                }, option: opt)
            }
            
        }
    
//        func token(qiniuToken:String) -> String {
//            return self.createQiniuToken(fileName: qiniuToken)
//        }
    
//        func hmacsha1WithString(str: String, secretKey: String) -> NSData {
//
//            let cKey  = secretKey.cString(using: String.Encoding.ascii)
//            let cData = str.cString(using: String.Encoding.ascii)
//
//            var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
//            CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
//            let hmacData: NSData = NSData(bytes: result, length: (Int(CC_SHA1_DIGEST_LENGTH)))
//            return hmacData
//        }
    
//        func createQiniuToken(fileName: String) -> String {
//
//            let oneHourLater = NSDate().timeIntervalSince1970 + 3600
//            let putPolicy: NSDictionary = ["scope": kQiniuBucket, "deadline": NSNumber(value: UInt64(oneHourLater))]
//            let encodedPutPolicy = QNUrlSafeBase64.encode(putPolicy.jsonString())
//            let sign = self.hmacsha1WithString(str: encodedPutPolicy!, secretKey: kQiniuSecretKey)
//            let encodedSign = QNUrlSafeBase64.encode(sign as Data!)
//
//            return kQiniuAccessKey + ":" + encodedSign! + ":" + encodedPutPolicy!
//        }
    
  
        
//        func uploadVideoData(video:Data , token:String, result: @escaping (_ progress: Float? , _ imageKey:String? ) -> ()) {
//
//
//
//            let opt = QNUploadOption(mime: nil, progressHandler: {(key, progres) in
//
//                result(progres, nil)
//            }, params: nil, checkCrc: true, cancellationSignal: nil)
//
//
//
//            if let manager = QNUploadManager() {
//                manager.put(video, key: nil, token: token, complete: { (Info, key, resp) in
//
//                    if (Info?.isConnectionBroken)! {
//                       Tool.confirm(title: "温馨提示", message: "网络连接错误", controller: self.controller)
//                        return
//                    }
//
//                    if let imageKey = resp?["key"] as? String {
//
//                        result(nil, imageKey)
//                    }
//
//                }, option: opt)
//            }
//
//        }
//
//        func upVideoDatas(videos:[Data] , result: @escaping (_ progress: Float? , _ imageKey:String? ) -> (),allTasksCompletion:@escaping () -> () ) {
//
//            if (Index < videos.count) {
//
//                uploadVideoData(video: videos[Index], result: { (progres, imageKey) in
//
//                    if (imageKey != nil) {
//
//                        result(progres, imageKey)
//
//                        self.Index += 1
//
//                        self.upVideoDatas(videos: videos, result: result, allTasksCompletion: allTasksCompletion)
//                    }
//                })
//            }else{
//                allTasksCompletion()
//                Index = 0
//            }
//
//        }
//
    
//        func upImageDatas(images:[Data] , result: @escaping (_ progress: Float? , _ imageKey:String? ) -> (),allTasksCompletion:@escaping () -> () ) {
//
//            if (Index < images.count) {
//
//                uploadImageData(image: images[Index], result: { (progres, imageKey) in
//
//                    if (imageKey != nil) {
//
//                        result(progres, imageKey)
//
//                        self.Index += 1
//
//                        self.upImageDatas(images: images, result: result, allTasksCompletion: allTasksCompletion)
//                    }
//                })
//            }else{
//                allTasksCompletion()
//                Index = 0
//            }
//
//        }
    
    }

