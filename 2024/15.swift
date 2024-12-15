#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

let inputParts = input.split(separator: "\n\n")
let inputMapLines = inputParts[0].split(separator: "\n")
let inputDirections = inputParts[1].replacingOccurrences(of: "\n", with: "")

func solve(_ inputMapLines: [Substring]) -> Int {
    var map: [XY: Tile] = Dictionary(uniqueKeysWithValues: inputMapLines.enumerated().flatMap { y, line in
        line.enumerated().compactMap { x, char in
            Tile(rawValue: char).flatMap { (XY(x: x, y: y), $0) }
        }
    })
    let robotLocationCount = inputMapLines.joined().split(separator: "@")[0].count
    var robotLocation = XY(x: robotLocationCount % inputMapLines[0].count, y: robotLocationCount / inputMapLines[0].count)

    moveLoop: for direction in inputDirections {
        var boxesToPush: Set<XY> = []
        var checkLocations = [robotLocation.next(direction)]
        while let checkLocation = checkLocations.popLast() {
            let next = map[checkLocation]
            switch next {
            case .box:
                boxesToPush.insert(checkLocation)
                checkLocations.insert(checkLocation.next(direction), at: 0)
            case .boxLhs, .boxRhs:
                let otherHalf: Character = next == .boxLhs ? ">" : "<"
                boxesToPush.formUnion([checkLocation, checkLocation.next(otherHalf)])

                switch direction {
                case "^", "v":
                    checkLocations.insert(checkLocation.next(direction), at: 0)
                    checkLocations.insert(checkLocation.next(direction).next(otherHalf), at: 0)
                case ">" where next == .boxRhs, "<" where next == .boxLhs:
                    checkLocations.insert(checkLocation.next(direction), at: 0)
                case ">", "<": // skip next because it is part of the same box
                    checkLocations.insert(checkLocation.next(direction).next(direction), at: 0)
                default:
                    fatalError()
                }
            case .wall: continue moveLoop
            case .none: continue
            }
        }

        for (location, tile) in boxesToPush.map({ ($0.next(direction), map.removeValue(forKey: $0)!) }) {
            map[location] = tile
        }
        robotLocation = robotLocation.next(direction)
    }

    return map.compactMap { location, tile in
        switch tile {
        case .box: location.x + location.y * 100
        case .boxLhs: location.x + location.y * 100
        case .boxRhs, .wall: nil
        }
    }.reduce(0, +)
}

let result1 = solve(inputMapLines)
let result2 = solve(inputMapLines.map { line in
    Substring(line.map { char in
        switch char {
        case "#": "##"
        case ".": ".."
        case "O": "[]"
        case "@": "@."
        default: fatalError()
        }
    }.joined())
})

enum Tile: Character {
    case wall = "#"
    case box = "O"
    case boxLhs = "["
    case boxRhs = "]"
}

struct XY: Hashable, CustomDebugStringConvertible {
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
    var debugDescription: String {
        "(x: \(x), y: \(y))"
    }
}

print("part1", result1, result1 == 1457740)
print("part2", result2, result2 == 1467145)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
