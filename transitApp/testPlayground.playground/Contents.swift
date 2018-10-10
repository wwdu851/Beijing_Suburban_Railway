//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var s = ["a","b"]

let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
if let firstNegative = numbers.first(where: { $0 > 6 }) {
    print("The first negative number is \(firstNegative).")
}



// Prints "The first negative number is -2."
