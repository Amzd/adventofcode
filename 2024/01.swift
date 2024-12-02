#!/usr/bin/env swift-sh

import Foundation
import RegexBuilder
import Testing

let input = try! String(contentsOfFile: "1.in")

var lhs: [Int] = []
var rhs: [Int] = []

for line in input.split(separator: "\n") {
    let matches = line.matches(of: OneOrMore(.digit))
    lhs.append(Int(matches[0].0)!)
    rhs.append(Int(matches[1].0)!)
}

lhs.sort()
rhs.sort()

assert(lhs.count == rhs.count)

var distance = 0
for (lhs, rhs) in zip(lhs, rhs) {
    distance += abs(lhs - rhs)
}

print("part1", distance)

/// int: count
var rhsCount = [Int: Int]()
for rhs in rhs {
    rhsCount[rhs, default: 0] += 1
}

var similarity = 0
for lhs in lhs {
    similarity += lhs * rhsCount[lhs, default: 0]
}

print("part2", similarity)
