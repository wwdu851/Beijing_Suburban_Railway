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
    
    func trainValidation(hour_1:Int,minute_1:Int,hour_2:Int,minute_2:Int) -> Bool{
        var return_value = false
        if hour_1 < hour_2{
            return_value = true
        }else if hour_1 == 23 && hour_2 == 00{
            return_value = true
        }else if hour_1 == hour_2{
            if minute_1 <= minute_2{
                return_value = true
            }
        }
        return return_value
    }
}
