#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

// MARK: - Parse
var antennas: [Character: Set<Location>] = [:]
var maxX = 0
var maxY = 0

for (y, line) in input.split(separator: "\n").enumerated() {
    for (x, antenna) in line.enumerated() where antenna != "." {
        antennas[antenna, default: []].insert(Location(x: x, y: y))
    }
    maxX = line.count - 1
    maxY = y
}

// MARK: - Calculate antinodes
var antinodes: Set<Location> = []
var reasonantAntinodes: Set<Location> = []

for locations in antennas.values {
    var otherLocations = locations
    while let location = otherLocations.popFirst() {
        for otherLocation in otherLocations {
            let mod = location - otherLocation
            assert(mod.x != 0 && mod.y != 0, "stride doesn't work with 0")
            for (x,y) in zip(stride(from: location.x, in: 0...maxX, by: mod.x), stride(from: location.y, in: 0...maxY, by: mod.y)) {
                reasonantAntinodes.insert(Location(x: x, y: y))
            }
            for (x,y) in zip(stride(from: location.x, in: 0...maxX, by: -mod.x), stride(from: location.y, in: 0...maxY, by: -mod.y)) {
                reasonantAntinodes.insert(Location(x: x, y: y))
            }
            antinodes.insert(location + mod)
            antinodes.insert(otherLocation - mod)
        }
    }
}
antinodes = antinodes.filter { 0...maxX ~= $0.x && 0...maxY ~= $0.y }

// MARK: - Helpers
func stride(from: Int, in range: ClosedRange<Int>, by: Int) -> StrideThrough<Int> {
    stride(from: from, through: by > 0 ? range.last! : range.first!, by: by)
}

struct Location: Hashable {
    let x, y: Int

    static func + (lhs: Self, rhs: Self) -> Self {
        Location(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func - (lhs: Self, rhs: Self) -> Self {
        Location(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

print("part1", antinodes.count)
print("part2", reasonantAntinodes.count)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
