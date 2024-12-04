#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

let input2d = input.split(separator: "\n").map { $0.map { $0 } }

func scan(from: (x: Int, y: Int), mod: (x: Int, y: Int), for string: String) -> Bool {
    guard let char = string.first else { return true }
    if char == input2d[from.x + mod.x, from.y + mod.y] {
        return string.isEmpty || scan(from: (from.x + mod.x, from.y + mod.y), mod: mod, for: String(string.dropFirst()))
    }
    return false
}

for (y, row) in input2d.enumerated() {
    for (x, char) in row.enumerated() {
        if char == "X" {
            if scan(from: (x,y), mod: (-1,-1), for: "MAS") { result1 += 1 }
            if scan(from: (x,y), mod: (-1, 0), for: "MAS") { result1 += 1 }
            if scan(from: (x,y), mod: (-1, 1), for: "MAS") { result1 += 1 }
            if scan(from: (x,y), mod: ( 0, 1), for: "MAS") { result1 += 1 }
            if scan(from: (x,y), mod: ( 1,-1), for: "MAS") { result1 += 1 }
            if scan(from: (x,y), mod: ( 1, 0), for: "MAS") { result1 += 1 }
            if scan(from: (x,y), mod: ( 1, 1), for: "MAS") { result1 += 1 }
            if scan(from: (x,y), mod: ( 0,-1), for: "MAS") { result1 += 1 }
        }
        if char == "A" {
            let tl = scan(from: (x-2,y-2), mod: (1, 1), for: "MAS") || scan(from: (x-2,y-2), mod: (1, 1), for: "SAM")
            let bl = scan(from: (x-2,y+2), mod: (1,-1), for: "MAS") || scan(from: (x-2,y+2), mod: (1,-1), for: "SAM")
            if tl && bl {
                result2 += 1
            }
        }
    }
}


extension Array where Element == [Character] {
    subscript(x: Index, y: Index) -> Character? {
        if self.indices.contains(y), self[y].indices.contains(x) {
            return self[y][x]
        }
        return nil
    }
}


print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)

