//
//  Extensions.swift
//  transitApp
//
//  Created by William Du on 2018/6/7.
//  Copyright © 2018年 William Du. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
}

