//
//  timeTable.swift
//  transitApp
//
//  Created by William Du on 2017/7/28.
//  Copyright © 2017年 William Du. All rights reserved.
//

import Foundation
import UIKit

struct timeTable{
    
    
    
    func getDate() -> Int{
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: date)
        
        return component
    }
    
}
