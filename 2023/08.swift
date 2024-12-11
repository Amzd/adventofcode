#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

let split = input.split(separator: "\n\n")
let steps: [Int] = split[0].map { $0 == "L" ? 0 : 1 }
let network: [Substring: [Substring]] = Dictionary(uniqueKeysWithValues: split[1].split(separator: "\n").map {
    let split = $0.split(separator: " = (")
    return (split[0], split[1].dropLast().split(separator: ", "))
})

var currentStep: Substring = "AAA"
var result1 = 0
while currentStep != "ZZZ" {
    currentStep = network[currentStep]![steps[result1 % steps.count]]
    result1 += 1
}

var stepsToZ: [Int] = [result1]
for firstStep in network.keys.filter({ $0.last == "A" && $0 != "AAA" }) {
    var step = firstStep
    var i = 0
    while step.last != "Z" {
        step = network[step]![steps[i % steps.count]]
        i += 1
    }
    assert(network[step]![steps[i % steps.count]] == network[firstStep]![steps[1]], "input does not loop")
    assert(i % steps.count == 0, "input does not loop")
    stepsToZ.append(i)
}
let result2 = stepsToZ.dropFirst().reduce(stepsToZ[0], lcm)

/// Returns the Greatest Common Divisor of two numbers.
func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

/// Returns the least common multiple of two numbers.
func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}

print("part1", result1, result1 == 16897)
print("part2", result2, result2 == 16563603485021)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
