#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

// TODO: Good luck

print("part1", result1, result1 == 0)
print("part2", result2, result2 == 0)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
