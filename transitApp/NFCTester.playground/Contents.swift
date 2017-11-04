//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


func getDate() -> Int{
    let date = Date()
    let calendar = Calendar(identifier: .gregorian)
    let component = calendar.component(.weekday, from: date)
    
    return component
}
