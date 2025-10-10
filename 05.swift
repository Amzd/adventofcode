#!/usr/bin/env swift

import Foundation

var input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
let start = Date()
var result1 = 0
var result2 = 0

let split = input.split(separator: "\n\n")
let rules = split[0].split(separator: "\n").map {
    let xy = $0.split(separator: "|")
    return (x: Int(xy[0])!,y: Int(xy[1])!)
}
let pagesBefore = Dictionary(grouping: rules, by: { $0.y }).mapValues { Set($0.map(\.x)) }

for update in split[1].split(separator: "\n") {
    let pages = update.split(separator: ",").map(String.init).compactMap(Int.init)
    let pairs = Array(zip(pages.dropLast(), pages.dropFirst()))
    if let firstNotSorted = pairs.firstIndex(where: { lhs, rhs in
        !pagesBefore[rhs, default: []].contains(lhs)
    }) {
        if firstNotSorted > pages.count/2 {
            result2 += pages[pages.count/2]
        } else {
            let sortedPages = pages.sorted { lhs, rhs in
                !pagesBefore[rhs, default: []].contains(lhs)
            }
            result2 += sortedPages[pages.count/2]
        }
    } else {
        result1 += pages[pages.count/2]
    }
}

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
