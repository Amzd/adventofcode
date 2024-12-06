#!/usr/bin/env swift

import Foundation

let start = Date()
var input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result2 = 0

let input2d: [[Character]] = input.split(separator: "\n").map { $0.map { $0 } }
let beforeGuard = input.split(separator: "^")[0].split(separator: "\n")
var cursor = Cursor(position: .init(x: beforeGuard.last!.count, y: beforeGuard.count - 1), facing: .up)
var visited: Set<Cursor.Position> = [cursor.position]

while let next = input2d[cursor.next.position] {
    if next == "#" {
        cursor.facing = cursor.facing.rotated
    } else {
        if visited.insert(cursor.next.position).inserted {
            var loopedCursor = cursor
            var loopedVisitedCorners = Set<Cursor>()
            var loopedInput2d = input2d
            loopedInput2d[cursor.next.position.y][cursor.next.position.x] = "#"
            o: while let next = loopedInput2d[loopedCursor.next.position] {
                if next == "#" {
                    if !loopedVisitedCorners.insert(loopedCursor).inserted {
                        result2 += 1
                        break o
                    }
                    loopedCursor.facing = loopedCursor.facing.rotated
                } else {
                    loopedCursor = loopedCursor.next
                }
            }
        }
        cursor = cursor.next
    }
}

enum Facing: String, CaseIterable {
    case up, right, down, left

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

struct Cursor: Hashable {
    struct Position: Hashable {
        var x: Int
        var y: Int
    }
    var position: Position
    var facing: Facing

    var next: Self {
        var copy = self
        copy.position.x = copy.position.x + facing.mod.x
        copy.position.y = copy.position.y + facing.mod.y
        return copy
    }
}

extension Array where Element == [Character] {
    subscript(position: Cursor.Position) -> Character? {
        self.indices.contains(position.y) && self[position.y].indices.contains(position.x) ? self[position.y][position.x] : nil
    }
}

print("part1", visited.count)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
