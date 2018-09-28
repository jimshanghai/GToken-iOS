//
//  UIbutton+extension.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/9/14.
//  Copyright © 2018年 scn. All rights reserved.
//
import UIKit
import Foundation
struct RuntimeKey {
    static let zm_eventUnavailable = UnsafeRawPointer.init(bitPattern: "zm_eventUnavailable".hashValue)!
    static let eventInterval = 1.5 // 按钮重复点击间隔
}

protocol SelfAware: class {
    static func awake()
}
class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate(capacity: typeCount)
    }
}
extension UIApplication {
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}

extension UIButton: SelfAware {
    static func awake() {
        UIButton.classInit()
    }
    
    static func classInit() {
        swizzleMethod
    }
    
    private static let swizzleMethod: Void = {
        let normalSelector = #selector(UIButton.sendAction(_:to:for:))
        let swizzledSelector = #selector(swizzled_senderAction(_:to:event:))
        let originalMethod = class_getInstanceMethod(UIButton.self, normalSelector)
        let swizzledMethod = class_getInstanceMethod(UIButton.self, swizzledSelector)
        
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        
        let isAdd = class_addMethod(UIButton.self, normalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if isAdd {
            class_replaceMethod(UIButton.self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        
    }()
    
    @objc private func swizzled_senderAction(_ action: Selector, to: Any?, event: UIEvent?) {
                print("警告      我是按钮被点击了")
        if eventUnavailable == nil {
            eventUnavailable = false
        }
        if !eventUnavailable! {
            self.eventUnavailable = true
            swizzled_senderAction(action, to: to, event: event)
            DispatchQueue.main.asyncAfter(deadline: .now() + RuntimeKey.eventInterval, execute: {
                self.eventUnavailable = false
            })
        }
    }
    
    private var eventUnavailable: Bool? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_eventUnavailable, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_eventUnavailable) as? Bool
        }
    }
    
}
