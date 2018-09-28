//
//  OwnCell.swift
//  edc_wallet_swift
//
//  Created by Netban on 2018/8/14.
//  Copyright © 2018年 scn. All rights reserved.
//

import UIKit

class OwnCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
