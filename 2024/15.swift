#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result2 = 0

let inputParts = input.split(separator: "\n\n")
let inputMapLines = inputParts[0].split(separator: "\n")
let inputDirections = inputParts[1].replacingOccurrences(of: "\n", with: "")
var map: [XY: Tile] = Dictionary(uniqueKeysWithValues: inputMapLines.enumerated().flatMap { (y, line) in
    line.enumerated().compactMap { x, char in
        Tile(rawValue: char).flatMap { (XY(x: x, y: y), $0) }
    }
})
let robotLocationYX = inputMapLines.joined().split(separator: "@")[0].count.quotientAndRemainder(dividingBy: inputMapLines[0].count)
var robotLocation = XY(x: robotLocationYX.1, y: robotLocationYX.0)

moveLoop: for direction in inputDirections {
    var boxesToPush: [XY] = []
    var checkLocation = robotLocation.next(direction)
    while let next = map[checkLocation] {
        switch next {
        case .box: boxesToPush.insert(checkLocation, at: 0)
        case .wall: continue moveLoop
        }
        checkLocation = checkLocation.next(direction)
    }
    if !boxesToPush.isEmpty {
        for (newLocation, oldLocation) in zip([checkLocation] + boxesToPush.dropLast(), boxesToPush) {
            map[newLocation] = map.removeValue(forKey: oldLocation)!
        }
    }
    robotLocation = robotLocation.next(direction)
}

let result1 = map.compactMap { location, tile in
    switch tile {
    case .box: location.x + location.y * 100
    case .wall: nil
    }
}.reduce(0, +)

enum Tile: Character {
    case wall = "#"
    case box = "O"
}

struct XY: Hashable {
    let x, y: Int

    func next(_ direction: Character) -> Self {
        switch direction {
        case "^": .init(x: x, y: y-1)
        case ">": .init(x: x+1, y: y)
        case "v": .init(x: x, y: y+1)
        case "<": .init(x: x-1, y: y)
        default: fatalError()
        }
    }
}

print("part1", result1, result1 == 1457740)
print("part2", result2, result2 == 0)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
