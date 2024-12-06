#!/usr/bin/env swift

import Foundation

let start = Date()
var input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result2 = 0

enum Facing: Character, CaseIterable {
    case up = "^"
    case right = ">"
    case down = "v"
    case left = "<"

    var rotated: Self {
        if let index = Self.allCases.firstIndex(of: self), index + 1 < Self.allCases.endIndex {
            return Self.allCases[index + 1]
        }
        return Self.allCases.first!
    }
    var mod: (x: Int, y: Int) {
        switch self {
        case .up: (0, -1)
        case .right: (1, 0)
        case .down: (0, 1)
        case .left: (-1, 0)
        }
    }
}

let input2d: [[Character]] = input.split(separator: "\n").map { $0.map { $0 } }
let beforeGuard = input.split(separator: "^")[0].split(separator: "\n")
var location = (x: beforeGuard.last!.count, y: beforeGuard.count - 1)
var facing = Facing.up
var visited: [String: Bool] = [String(describing: location): true]

while let next = input2d[location.x + facing.mod.x, location.y + facing.mod.y] {
    if next == "#" {
        facing = facing.rotated
    } else {
        location.x += facing.mod.x
        location.y += facing.mod.y
        visited[String(describing: location)] = true
    }
}

extension Array where Element == [Character] {
    subscript(x: Index, y: Index) -> Character? {
        self.indices.contains(y) && self[y].indices.contains(x) ? self[y][x] : nil
    }
}

print("part1", visited.count)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
