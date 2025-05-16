#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

// TODO: Good luck

let input2d = input.split(separator: "\n").map { $0.map { $0 } }
let rowLength = input2d[0].count
let inputOneLine = input.replacingOccurrences(of: "\n", with: "")
let startLocation: (y: Int, x: Int) = inputOneLine.split(separator: "S")[0].count.quotientAndRemainder(dividingBy: rowLength) as (Int, Int)
let endLocation: (y: Int, x: Int) = inputOneLine.split(separator: "E")[0].count.quotientAndRemainder(dividingBy: rowLength) as (Int, Int)
var incompleteRoutes: Set<Set<Step>> = [[.start(at: .init(x: startLocation.x, y: startLocation.y))]]

while
}

enum Step: Hashable {
    case start(at: Location)
    case step(from: Location, to: Location)
    case turnLeft(at: Location)
    case turnRight(at: Location)
}

extension Collection {
    subscript(xy: Location) -> Element.Element? where Element: Collection, Index == Int, Element.Index == Int {
        indices.contains(xy.y) && self[xy.y].indices.contains(xy.x) ? self[xy.y][xy.x] : nil
    }
    // subscript(safe index: Index) -> Element? {
    //     indices.contains(index) ? self[index] : nil
    // }
}

struct Location: Hashable {
    let x, y: Int
}

print("part1", result1, result1 == 0)
print("part2", result2, result2 == 0)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
