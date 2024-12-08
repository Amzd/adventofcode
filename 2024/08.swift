#!/usr/bin/env swift

import Foundation

let start = Date()
var input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result2 = 0

struct XY: Hashable {
    let x, y: Int

    static func + (lhs: Self, rhs: Self) -> Self {
        XY(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func - (lhs: Self, rhs: Self) -> Self {
        XY(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
var antennas: [Character: Set<XY>] = [:]
var maxX = 0
var maxY = 0

for (y, line) in input.split(separator: "\n").enumerated() {
    for (x, antenna) in line.enumerated() where antenna != "." {
        antennas[antenna, default: []].insert(XY(x: x, y: y))
    }
    maxX = line.count - 1
    maxY = y
}

var antinodes: Set<XY> = []

for locations in antennas.values {
    var otherLocations = locations
    while let location = otherLocations.popFirst() {
        for otherLocation in otherLocations {
            let mod = location - otherLocation
            antinodes.insert(location + mod)
            antinodes.insert(otherLocation - mod)
        }
    }
}
antinodes = antinodes.filter {
    0...maxX ~= $0.x && 0...maxY ~= $0.y
}

print("part1", antinodes.count)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
