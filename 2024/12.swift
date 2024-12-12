#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

let input2d: [[Character]] = input.split(separator: "\n").map { $0.map { $0 }}
var regions: [Region] = []
var handled: Set<Location> = []
for (y, row) in input2d.enumerated() {
    for (x, char) in row.enumerated() {
        let location = Location(x: x, y: y)
        guard !handled.contains(location) else { continue }
        var newRegion = Region(type: char, insideLocations: [location])
        var toCheck = location.allDirections
        while !toCheck.isEmpty {
            var newToCheck: [Location] = []
            for toCheck in toCheck {
                if input2d[toCheck] == char {
                    if newRegion.insideLocations.insert(toCheck).inserted {
                        handled.insert(toCheck)
                        newToCheck.append(contentsOf: toCheck.allDirections)
                    }
                } else {
                    newRegion.perimeter += 1
                }
            }
            toCheck = newToCheck.filter { !newRegion.insideLocations.contains($0) }
        }
        regions.append(newRegion)
    }
}

let result1 = regions.map { $0.area * $0.perimeter }.reduce(0, +)
let result2 = regions.map { region in
    region.area * region.insideLocations.map {
        // I'd rather zip this but this saves 15% performance
        let allCorners = [([$0.up, $0.right], $0.up.right), ([$0.right, $0.down], $0.right.down), ([$0.down, $0.left], $0.down.left), ([$0.left, $0.up], $0.left.up)]
        return allCorners.filter { directions, diagonal in
            return switch directions.filter(region.insideLocations.contains).count {
            case 0: true
            case 2: !region.insideLocations.contains(diagonal)
            default: false
            }
        }.count
    }.reduce(0, +)
}.reduce(0, +)

struct Region: Hashable {
    var type: Character
    var insideLocations: Set<Location>
    var perimeter: Int = 0
    var area: Int { insideLocations.count }
}

struct Location: Hashable, Comparable {
    var x, y: Int

    static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.x, lhs.y) < (rhs.x, rhs.y)
    }

    var up: Location { Location(x: x, y: y-1) }
    var right: Location { Location(x: x+1, y: y) }
    var down: Location { Location(x: x, y: y+1) }
    var left: Location { Location(x: x-1, y: y) }
    var allDirections: [Location] { [up, right, down, left] }
    var allDiagonals: [Location] { [up.right, right.down, down.left, left.up] }
}

extension Collection where Element: Collection, Index == Int, Element.Index == Int {
    subscript(xy: Location) -> Element.Element? {
        indices.contains(xy.y) && self[xy.y].indices.contains(xy.x) ? self[xy.y][xy.x] : nil
    }
}

print("part1", result1, result1 == 1471452)
print("part2", result2, result2 == 863366)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
