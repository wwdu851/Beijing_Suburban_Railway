//
//  CustomCell.swift
//  transitApp
//
//  Created by William Du on 2017/7/28.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var startPlace: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var endPlace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
