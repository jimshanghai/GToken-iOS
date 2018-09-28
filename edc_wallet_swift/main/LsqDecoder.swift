//
//  modelDecoder.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/20.
//  Copyright © 2018年 scn. All rights reserved.
//
import UIKit
enum LsqError: Error {
    case message(String)
}
struct LsqDecoder {
    //TODO:转换模型
    static func decode<T>(_ type: T.Type, param: [String:Any]) throws -> T where T: Decodable{
        guard let jsonData = self.getJsonData(with: param) else {
            throw LsqError.message("转换data失败")
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            throw LsqError.message("转换模型失败")
        }
        return model
    }
    static func getJsonData(with param: Any)->Data?{
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}
