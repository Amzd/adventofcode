#!/usr/bin/env swift

import Foundation
import RegexBuilder

let input = try! String(contentsOfFile: "03.input")

let in2d: [[Character]] = input.split(separator: "\n").map { $0.map { $0 } }

var sumOfPartNr = 0
var allowed = Set("0123456789.")
/// [x,y]: [part]
var gears = [[Int]: [Int]]()

for (y, row) in input.split(separator: "\n").map(String.init).enumerated() {
    nextMatch: for match in row.matches(of: { OneOrMore(.digit) }) {
        let minX = match.0.startIndex.utf16Offset(in: row) - 1
        let maxX = match.0.endIndex.utf16Offset(in: row)

        var neighboursSymbol = false
        for x in minX...maxX {
            for y in y-1...y+1 {
                neighboursSymbol = neighboursSymbol || !allowed.contains(in2d[x, y])
                if in2d[x, y] == "*" {
                    gears[[x,y], default: []].append(Int(match.0)!)
                }
            }
        }
        if neighboursSymbol {
            sumOfPartNr += Int(match.0)!
        }
    }
}


print("part1", sumOfPartNr)
print("part2", gears.values.filter { $0.count > 1 } .map { $0.reduce(1, *) } .reduce(0, +))

extension Array where Element == [Character] {
    subscript(x: Index, y: Index) -> Character {
        if self.indices.contains(y), self[y].indices.contains(x) {
            return self[y][x]
        }
        return "."
    }
}
