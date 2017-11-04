//
//  DetailCell.swift
//  transitApp
//
//  Created by William Du on 2017/8/4.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var timePlace: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
