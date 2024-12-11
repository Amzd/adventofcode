#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

var numberCounts: [Double: Int] = [:]
for number in input.split(separator: "\n")[0].split(separator: " ").map({ Double($0)! }) {
    numberCounts[number, default: 0] += 1
}


for _ in 0..<25 {
    var newCounts: [Double: Int] = [:]
    for (number, count) in numberCounts where count > 0 {
        for result in blink(number) {
            newCounts[result, default: 0] += count
        }
    }
    numberCounts = newCounts
}
let result1 = numberCounts.values.reduce(0, +)
for _ in 25..<75 {
    var newCounts: [Double: Int] = [:]
    for (number, count) in numberCounts where count > 0 {
        for result in blink(number) {
            newCounts[result, default: 0] += count
        }
    }
    numberCounts = newCounts
}
let result2 = numberCounts.values.reduce(0, +)

func blink(_ number: Double) -> [Double] {
    if number == 0 {
        return [1]
    }
    let numOfDigits = numberOfDigits(of: number)
    if numOfDigits.truncatingRemainder(dividingBy: 2) == 0 {
        return split(number, numOfDigits: numOfDigits)
    }
    return [number * 2024]
}

func split(_ number: Double, numOfDigits: Double) -> [Double] {
    assert(numOfDigits.truncatingRemainder(dividingBy: 2) == 0)
    let lhs = floor(number / pow(10, numOfDigits/2))
    let rhs = number - lhs * pow(10, numOfDigits/2)
    return [lhs, rhs]
}

func numberOfDigits(of number: Double) -> Double {
    floor(log10(number)+1)
}

print("part1", result1, result1 == 200446)
print("part2", result2, result2 == 238317474993392)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
