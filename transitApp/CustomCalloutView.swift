//
//  CustomCalloutView.swift
//  transitApp
//
//  Created by William Du on 2018/6/5.
//  Copyright © 2018年 William Du. All rights reserved.
//

import UIKit
import MapKit

protocol CustomCalloutViewDelegate: class {
    func directionButtonTapped(_ calloutView: CustomCalloutView)
    func informationButtonTapped(_ calloutView: CustomCalloutView)
}

class CustomCalloutView: UIView,mapViewControllerDelegate{
    
    @IBOutlet weak var stationLabel: UILabel!
    
    @IBOutlet weak var first_line_label: UILabel!
    
    @IBOutlet weak var second_line_label: UILabel!
    
    @IBOutlet weak var third_line_label: UILabel!
    
    
    
    
    @IBOutlet weak var infoButtonOutlet: UIButton!
    @IBOutlet weak var directionButtonOutlet: UIButton!
    
    weak var delegate: CustomCalloutViewDelegate?
    
    var currentClicked = ""
    var stationName = ""
    
    override func awakeFromNib() {
        infoButtonOutlet.setTitle(NSLocalizedString("Information", comment: "xinxi"), for: .normal)
        self.layer.cornerRadius = 5
        infoButtonOutlet.layer.cornerRadius = 5
        directionButtonOutlet.layer.cornerRadius = 5
    }
    
    
    @IBAction func informationButton(_ sender: UIButton) {
        self.delegate?.informationButtonTapped(self)
    }
    
    @IBAction func DirectionButton(_ sender: UIButton) {
        self.delegate?.directionButtonTapped(self)
    }
    
    
    func changeTitle(_ currentTitle: String) {
        if currentTitle == "To" {
            self.directionButtonOutlet.setTitle("From", for: .normal)
        } else {
            self.directionButtonOutlet.setTitle("To", for: .normal)
        }
        print(currentTitle)
    }
    
    func passOffStationName(_ mapView: mapViewController) {
        print("Pass name")
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
