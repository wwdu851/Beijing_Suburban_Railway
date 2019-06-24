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
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var firstLine: UILabel!
    @IBOutlet weak var secondLine: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var lineName: UILabel!
    @IBOutlet weak var rideDuration: UILabel!
    
    override func awakeFromNib() {
        // stackView.layer.cornerRadius = 5
        super.awakeFromNib()
        // Initialization code
        lineName.text = NSLocalizedString("Line S2", comment: "s2xian")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
