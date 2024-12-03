#!/usr/bin/env swift

import Foundation
import RegexBuilder

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

let x = Reference(Int.self)
let y = Reference(Int.self)

var enabled = true
for match in input.matches(of: {
    ChoiceOf {
        "do()"
        "don't()"
        Local {
            "mul("
            Capture(OneOrMore(.digit), as: x, transform: { Int($0)! })
            ","
            Capture(OneOrMore(.digit), as: y, transform: { Int($0)! })
            ")"
        }
    }
}) {
    if match.0 == "do()" {
        enabled = true
    } else if match.0 == "don't()" {
        enabled = false
    } else if enabled {
        result1 += match[x] * match[y]
        result2 += match[x] * match[y]
    } else {
        result1 += match[x] * match[y]
    }
}

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
