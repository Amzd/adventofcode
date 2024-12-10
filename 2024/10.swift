#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

let inputDict: [Location: Int] = Dictionary(uniqueKeysWithValues: input.split(separator: "\n").enumerated().flatMap { y, row in
    row.enumerated().map { x, char in (Location(x: x, y: y), Int(String(char))!) }
})

for (location, height) in inputDict where height == 0 {
    var trailheads: Set<Location> = [location]
    var trails: Set<[Location]> = [[location]]
    for i in 1...9 {
        var newTrailheads: Set<Location> = []
        var newTrails: Set<[Location]> = []
        for trailhead in trailheads {
            for nextTrailhead in trailhead.allDirections where inputDict[nextTrailhead] == i {
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

struct Location: Hashable {
    let x, y: Int

    var up: Location { Location(x: x, y: y-1) }
    var right: Location { Location(x: x+1, y: y) }
    var down: Location { Location(x: x, y: y+1) }
    var left: Location { Location(x: x-1, y: y) }
    var allDirections: [Location] { [up, right, down, left] }
}

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
