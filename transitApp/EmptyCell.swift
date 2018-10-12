//
//  EmptyCell.swift
//  transitApp
//
//  Created by William Du on 2018/10/11.
//  Copyright © 2018 William Du. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    
    @IBOutlet weak var titleOutlet: UILabel!
    
    @IBOutlet weak var contentOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
