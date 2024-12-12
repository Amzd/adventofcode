#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

let input2d: [[Character]] = input.split(separator: "\n").map { $0.map { $0 }}

result1 = regions(from: input2d).map { $0.area * $0.perimeter }.reduce(0, +)

let rows2x = input2d.map { zip($0, $0).flatMap { [$0, $1] }}
let input2d2x = zip(rows2x, rows2x).flatMap { [$0, $1] }

for region in regions(from: input2d2x) {
    let corners = region.insideLocations.filter {
        switch $0.allDirections.filter(region.insideLocations.contains).count {
        case 2: true
        case 4: $0.allDiagonals.filter(region.insideLocations.contains).count == 3
        default: false
        }
    }
    result2 += region.area / 4 * corners.count
}

func regions(from input2d: [[Character]]) -> [Region] {
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
    return regions
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
