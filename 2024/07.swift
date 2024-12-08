#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

for line in input.split(separator: "\n") {
    let split = line.split(separator: ":")
    let result = Double(split[0])!
    let numbers = split[1].split(separator: " ").compactMap { Double($0) }
    var possibleResults: Set<Result> = [Result(value: numbers[0])]
    for number in numbers.dropFirst() {
        var newPossibleResults = Set<Result>()
        for p in possibleResults {
            newPossibleResults.insert(.init(neededConcat: p.neededConcat, value: p.value * number))
            newPossibleResults.insert(.init(neededConcat: p.neededConcat, value: p.value + number))
            newPossibleResults.insert(.init(neededConcat: true, value: p.value * pow(10, floor(log10(number)+1)) + number))
            // can increase performance by checking after every concat if this path was also reachable without concat and dropping that path but idc rn
        }
        possibleResults = newPossibleResults
    }

    if possibleResults.contains(Result(neededConcat: false, value: result)) {
        result1 += Int(result)
        result2 += Int(result)
    } else if possibleResults.contains(Result(neededConcat: true, value: result)) {
        result2 += Int(result)
    }
}

struct Result: Hashable {
    var neededConcat: Bool = false
    let value: Double
}

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
