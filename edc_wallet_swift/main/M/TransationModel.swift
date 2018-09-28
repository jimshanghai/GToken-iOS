//
//  TransationModel.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/20.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit
//    id = 352;
//    name = test;
//    numbers = 8832494848;
//    remarks = 0827;
//    state = 1;
//    txhash = 0x97c5686b05703cd524adcb30a8c08c7d8467a2dc18a6b4189cc1497b18f95599;
//    type = 1;
//    used = "0.1";
//    "used_type" = 2;
//}
class TransationModel:Codable  {
    var id :Int!
    var state :String!
    var after :String!
    var used_type :String!
    var used :String!
    var txhash :String!
    var created_at :String!
    var name :String!
    var numbers :String!
    var avatar :String!
    var remarks :String!
}
