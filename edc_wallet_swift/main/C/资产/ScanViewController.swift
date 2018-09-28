//
//  ScanViewController.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/14.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

private let scanAnimationDuration = 3.0//扫描时长

class ScanViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: -
    //MARK: Global Variables
    
    var scanPane: UIImageView!///扫描框
    var activityIndicatorView: UIActivityIndicatorView!
    var bottomView:UIView?
    var barframe:CGRect = CGRect.zero
    var lightOn = false///开光灯
    
    //MARK: -
    //MARK: Lazy Components
    
    lazy var scanLine : UIImageView =
        {
            
            let scanLine = UIImageView()
            scanLine.frame = CGRect(x: 0, y: 0, width: self.scanPane.bounds.width, height: 3)
            scanLine.image = UIImage(named: "QRCode_ScanLine")
            
            return scanLine
            
    }()
     var scanSession :  AVCaptureSession?
    var scanPreviewLayer :AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("扫描二维码", comment: "")
//        if( NSString(string: UIDevice.current.systemVersion).floatValue ) < 10{
            self.edgesForExtendedLayout = []
//        }
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,  action: #selector(backToPrevious))
        leftBarBtn.image = UIImage(named: "返回")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        initSubViews()
        setupScanSession()
        // Do any additional setup after loading the view.
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
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    private func initSubViews() {
        
        let label: UILabel = UILabel.init()
        label.textColor = kOrangeColor
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = NSLocalizedString("将取景框对准二维，即可自动扫描", comment: "")
        self.view.addSubview(label)
     
        scanPane = UIImageView.init(image: UIImage.init(named: "QRCode_ScanBox"))
        self.view.addSubview(scanPane)
        scanPane.snp.makeConstraints { (make) in
//            make.top.equalTo(label.snp.bottom).offset(40)
//            make.left.equalTo((kScreenWidth-226)/2.0)
//            make.center.equalTo(self.view.center)
            make.centerX.equalTo(self.view.center.x)
            make.centerY.equalTo(self.view.center.y-kNavBarHeight_StatusHeight(self))
            make.size.equalTo(CGSize(width: 226, height: 188))
        }
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(scanPane.snp.top).offset(-20)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        activityIndicatorView = UIActivityIndicatorView.init()
        activityIndicatorView.color = UIColor.orange
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView!.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
        }
        initBottomView()
        view.layoutIfNeeded()
        scanPane.addSubview(scanLine)
        
        
    }
    private func initBottomView() {
        bottomView = {
            let tempbottomView = UIView.init(frame: CGRect(x: 0, y: kScreenHeight - kNavBarHeight_StatusHeight(self) , width: kScreenWidth, height: kNavBarHeight_StatusHeight(self)+30))
            tempbottomView.backgroundColor = kOrangeColor
            view.addSubview(tempbottomView)
             let  height : CGFloat  =   kNavBarHeight_StatusHeight(self) + 30
            tempbottomView.snp.makeConstraints { (make) in
                make.bottom.equalTo(0)
                make.width.equalTo(kScreenWidth)
                make.height.equalTo(height)
            }
            return tempbottomView
        }()
        
        let imageViewWidth:CGFloat = kScreenWidth/3
        for index in 0...3 {
            let imageView = UIImageView.init()
            imageView.tintColor = UIColor.white
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRect(x: imageViewWidth * CGFloat(index), y: 10, width: imageViewWidth, height: ((bottomView?.frame.size.height)!/2))
            
            if index == 0 {
                imageView.image = UIImage.init(named: "qrcode_scan_btn_photo_nor")
                
            } else if index == 1 {
                imageView.image = UIImage.init(named: "qrcode_scan_btn_flash_nor")
                
            }else if index == 2 {
                imageView.image = UIImage.init(named: "qrcode_scan_btn_myqrcode_nor")
                
            }
            
            imageView.contentMode = .center;
            
            let button: UIButton = UIButton.init()
            button.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageView.frame.size.height)
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(bottomBtnClick(sender:)), for: .touchUpInside)
            button.tag = index
            imageView.addSubview(button)
            bottomView?.addSubview(imageView)
            
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        barframe  =   (self.tabBarController?.tabBar.frame)!
        self.tabBarController?.tabBar.frame = CGRect.zero
        startScan()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.frame = barframe
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: Interface Components
    
    func setupScanSession()
    {
        

        
        //设置捕捉设备
        let device = AVCaptureDevice.default(for: AVMediaType.video)
            do {
                //初始化媒体捕捉的输入流
                //设置设备输入输出
                let input = try AVCaptureDeviceInput(device: device!)
                //设置会话
                scanSession = AVCaptureSession()
                
                if (scanSession?.canAddInput(input))!
                {
                    scanSession?.addInput(input)
                }
            }  catch  {
                // 捕获到移除就退出
                //摄像头不可用
                
                Tool.confirm(title: NSLocalizedString("温馨提示", comment: ""), message: NSLocalizedString("摄像头不可用", comment: ""), controller: self)
                print(error)
                return
            }
            
            let output = AVCaptureMetadataOutput()
        
            if (scanSession?.canAddOutput(output))!
            {
                scanSession?.addOutput(output)
            }
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            //预览图层
            scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession!)
            scanPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            scanPreviewLayer?.frame = view.layer.bounds
            view.layer.insertSublayer(scanPreviewLayer!, at: 0)
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = (self.scanPreviewLayer?.metadataOutputRectConverted(fromLayerRect: self.scanPane.frame))!
            })
            //保存会话
//            self.scanSession = scanSession
        
    }
    
    //MARK: -
    //MARK: Target Action
    @objc func bottomBtnClick(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            photo()
        case 1:
            light(sender)
        case 2:
            
            let vc2:MyQRCodeViewController = MyQRCodeViewController()
            
            self.navigationController?.pushViewController(vc2, animated: false)
            
        default:
            print("\(sender.tag)")
            
        }
        
        
        
    }
    //闪光灯
    func light(_ sender: UIButton)
    {
        
        lightOn = !lightOn
        sender.isSelected = lightOn
        turnTorchOn()
        
    }
    
    //相册
    func photo()
    {
        
        Tool.shareTool.choosePicture(self, editor: true, options: .photoLibrary) {[weak self] (image) in
            
            self!.activityIndicatorView.startAnimating()
            
            DispatchQueue.global().async {
               let  recognizeResult = image.recognizeQRCode()
               let result = recognizeResult?.characters.count > 0 ? recognizeResult : NSLocalizedString("无法识别", comment: "")
             
                DispatchQueue.main.async {
                    if(result?.hasPrefix("https://wallet.edc.org.cn"))!{
                        self!.activityIndicatorView.stopAnimating()
                        let  out = OutDetail2ViewController()
                        let array =  result?.split(separator: "/", maxSplits: 2, omittingEmptySubsequences: true) as! NSArray
                        out.out2VM.tonumbers = array.lastObject as! String
                        self!.navigationController?.pushViewController(out, animated: true)
                    }else{
                         self!.activityIndicatorView.stopAnimating()
                        Tool.confirm(title: NSLocalizedString("扫描结果", comment: ""), message: result, controller: self!)
                    }
                    
                   
                }

            }
        }
        
    }
    
    //MARK: -
    //MARK: Private Methods
    
    //开始扫描
    fileprivate func startScan()
    {
        
       scanLine.layer.add(scanAnimation(), forKey: "scan")
        
//        guard let scanSession = scanSession else { return }
        
        if !(scanSession?.isRunning)!
        {
            scanSession?.startRunning()
        }
        
        
    }
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation
    {
        
        let startPoint = CGPoint(x: scanLine .center.x  , y: 1)
        let endPoint = CGPoint(x: scanLine.center.x, y: scanPane.bounds.size.height - 2)
        
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }
    
    
    ///闪光灯
    private func turnTorchOn()
    {
        
        guard let device =  AVCaptureDevice.default(for: AVMediaType.video) else
        {
            
            if lightOn
            {
                
                Tool.confirm(title: NSLocalizedString("温馨提示", comment: ""), message: NSLocalizedString("闪光灯不可用", comment: ""), controller: self)
                
            }
            
            return
        }
        
        if device.hasTorch
        {
            do
            {
                try device.lockForConfiguration()
                
                if lightOn && device.torchMode == .off
                {
                    device.torchMode = .on
                }
                
                if !lightOn && device.torchMode == .on
                {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            }
            catch{ }
            
        }
        
    }
    
    //MARK: -
    //MARK: Dealloc
    
    deinit
    {
        ///移除通知
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //停止扫描
        self.scanLine.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        
        //播放声音
        Tool.playAlertSound(sound: "1109")
        
        //扫完完成
        if metadataObjects.count > 0
        {
            
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            {
                
                if(resultObj.stringValue?.hasPrefix("https://wallet.edc.org.cn"))!{
                    let  out = OutDetail2ViewController()
                    let array =  resultObj.stringValue?.split(separator: "/", maxSplits: 2, omittingEmptySubsequences: true) as! NSArray
                    out.out2VM.tonumbers = array.lastObject as! String
                    self.navigationController?.pushViewController(out, animated: true)
                }else{
                    Tool.confirm(title: NSLocalizedString("扫描结果", comment: ""), message: resultObj.stringValue, controller: self,handler: { (_) in
                        //继续扫描
                        self.startScan()
                    })
                }
                
            }
            
        }
    }

}

