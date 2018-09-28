//
//  ContactCell.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/15.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var numbers: UILabel!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.icon.layer.cornerRadius = 35/2
        self.icon.layer.masksToBounds = true
        self.icon.layer.borderColor = UIColor.white.cgColor
        self.icon.layer.borderWidth = 1.0;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
