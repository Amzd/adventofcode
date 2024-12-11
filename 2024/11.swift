#!/usr/bin/env swift

import Foundation

let start = Date()
var input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
// input = "125 17"
var result1 = 0
var result2 = 0

var row = input.split(separator: "\n")[0].split(separator: " ").map { Double($0)! }
for _ in 0..<25 {
    row = row.flatMap(blink)
}
result1 = row.count
for i in 25..<75 {
    print(i, -start.timeIntervalSinceNow)
    row = row.flatMap(blink)
}
result2 = row.count

func blink(_ number: Double) -> [Double] {
    if number == 0 {
        return [1]
    }
    let numOfDigits = numberOfDigits(of: number)
    // print(number, number, numOfDigits)
    if numOfDigits.truncatingRemainder(dividingBy: 2) == 0 {
        return split(number, numOfDigits: numOfDigits)
    }
    return [number * 2024]
}

func split(_ number: Double, numOfDigits: Double? = nil) -> [Double] {
    let numOfDigits = numOfDigits ?? numberOfDigits(of: number)
    assert(numOfDigits.truncatingRemainder(dividingBy: 2) == 0)
    let lhs = floor(number / pow(10, numOfDigits/2))
    let rhs = number - lhs * pow(10, numOfDigits/2)
    return [lhs, rhs]
}

// func numberOfDigits(of number: Double) -> Double {
//     floor(log10(number)+1)
// }
func numberOfDigits(of number: Double) -> Double {
    var count = 0.0
    var n = number
    while n >= 1 {
        n /= 10
        count += 1
    }
    return count
}

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
