#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

let input2d: [[Character]] = input.split(separator: "\n").map { $0.map { $0 }}
var regions: [Region] = []
for (y, row) in input2d.enumerated() {
    for (x, char) in row.enumerated() {
        let location = Location(x: x, y: y)
        guard !regions.contains(where: { $0.type == char && $0.insideLocations.contains(location) }) else { continue }
        var newRegion = Region(type: char, insideLocations: [location])
        var toCheck = location.allDirections
        while !toCheck.isEmpty {
            var newToCheck: [Location] = []
            for toCheck in toCheck {
                if input2d[toCheck] == char {
                    if newRegion.insideLocations.insert(toCheck).inserted {
                        newToCheck.append(contentsOf: toCheck.allDirections)
                    }
                } else {
                    newRegion.outsideChecks.append(toCheck)
                }
            }
            toCheck = newToCheck.filter { !newRegion.insideLocations.contains($0) }
        }
        regions.append(newRegion)
    }
}

result1 = regions.map { $0.area * $0.perimeter }.reduce(0, +)

for region in regions {
    let corners = region.insideLocations.map {
        let outsideCorners = zip($0.allDirections, $0.allDirections.dropFirst() + [$0.allDirections[0]]).map { [$0, $1] }
        let allCorners = zip(outsideCorners, $0.allDiagonals)
        return allCorners.filter { directions, diagonal in
            return switch directions.filter(region.insideLocations.contains).count {
            case 0: true
            case 2: !region.insideLocations.contains(diagonal)
            default: false
            }
        }.count
    }.reduce(0, +)
    result2 += region.area * corners
}

struct Region: Hashable {
    var type: Character
    var outsideChecks: [Location] = []
    var insideLocations: Set<Location>
    var perimeter: Int { outsideChecks.count }
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
