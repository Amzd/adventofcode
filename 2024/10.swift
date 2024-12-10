#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

let input2d: [[Int]] = input.split(separator: "\n").map { $0.map { Int(String($0))! }}

for (y, row) in input2d.enumerated() {
    for (x, height) in row.enumerated() where height == 0 {
        var trailheads: Set<Location> = [Location(x: x, y: y)]
        var trails: Set<[Location]> = [[Location(x: x, y: y)]]
        for i in 1...9 {
            var newTrailheads: Set<Location> = []
            var newTrails: Set<[Location]> = []
            for trailhead in trailheads {
                for nextTrailhead in trailhead.allDirections where input2d[nextTrailhead] == i {
                    newTrailheads.insert(nextTrailhead)
                    for trail in trails where trail.last == trailhead {
                        newTrails.insert(trail + [nextTrailhead])
                    }
                }
            }
            trailheads = newTrailheads
            trails = newTrails
        }
        result1 += trailheads.count
        result2 += trails.count
    }
}

struct Location: Hashable {
    let x, y: Int

    var up: Location { Location(x: x, y: y-1) }
    var right: Location { Location(x: x+1, y: y) }
    var down: Location { Location(x: x, y: y+1) }
    var left: Location { Location(x: x-1, y: y) }
    var allDirections: [Location] { [up, right, down, left] }
}

extension Collection where Element: Collection, Index == Int, Element.Index == Int {
    subscript(xy: Location) -> Element.Element? {
        indices.contains(xy.y) && self[xy.y].indices.contains(xy.x) ? self[xy.y][xy.x] : nil
    }
}


print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
