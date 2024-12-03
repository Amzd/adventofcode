#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

func parse(withConditionals: Bool) -> Int {
    var result = 0
    let scanner = Scanner(string: input)
    while !scanner.isAtEnd {
        let enabledString = withConditionals ? scanner.scanUpToString("don't()") ?? "" : input
        let enabledScanner = Scanner(string: enabledString)
        while !enabledScanner.isAtEnd {
            _ = enabledScanner.scanUpToString("mul(")
            if let _ = enabledScanner.scanString("mul(") {
                if let x = enabledScanner.scanInt(),
                    let _ = enabledScanner.scanString(","),
                    let y = enabledScanner.scanInt(),
                    let _ = enabledScanner.scanString(")") {
                    result += x * y
                }
            } else {
                break
            }
        }

        if withConditionals {
            _ = scanner.scanString("don't()")
            _ = scanner.scanUpToString("do()")
            _ = scanner.scanString("do()")
        } else {
            break
        }
    }
    return result
}

print("part1", parse(withConditionals: false))
print("part2", parse(withConditionals: true))
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
