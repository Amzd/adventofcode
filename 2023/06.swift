#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 1
var result2 = 1

let lines = input.split(separator: "\n")
let times = lines[0].split(separator: " ").compactMap { Int($0) }
let distances = lines[1].split(separator: " ").compactMap { Int($0) }

for (time, distance) in zip(times, distances) {
    let firstValid = (1..<time).firstIndex { hold in (time - hold) * hold > distance }!
    result1 *= time - firstValid*2 + 1
}

let time = Int(lines[0].replacingOccurrences(of: " ", with: "").split(separator: ":")[1])!
let distance = Int(lines[1].replacingOccurrences(of: " ", with: "").split(separator: ":")[1])!
let firstValid = (1..<time).firstIndex { hold in (time - hold) * hold > distance }!
result2 *= time - firstValid*2 + 1

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
