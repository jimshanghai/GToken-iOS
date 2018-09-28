//
//  DetailCell.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
   
     @IBOutlet var  avatar:UIImageView!
     @IBOutlet var  after:UILabel!
     @IBOutlet var  ceated_at:UILabel!
     @IBOutlet var  mark:UILabel!
     @IBOutlet var  transation:UILabel!
     @IBOutlet var  name:UILabel!
     @IBOutlet var  number:UILabel!
     @IBOutlet var stateLable: UILabel!
    @IBOutlet var txHash: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatar.layer.cornerRadius = 45/2
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 1.0;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
