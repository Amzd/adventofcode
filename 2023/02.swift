#!/usr/bin/env swift

import Foundation

var sumOfIds = 0
var sumOfMaxColors = 0
for var line in try String(contentsOfFile: "02.input").split(separator: "\n").map(String.init) {
    // print(line)
    line = line.replacingOccurrences(of: "Game ", with: "")
    let gameSplit = line.split(separator: ": ")
    let game = Int(gameSplit[0])!
    var maxColors = [Substring: Int]()
    var isPossible = true
    for set in gameSplit[1].split(separator: "; ") {
        var colors = [Substring: Int]()
        set.split(separator: ", ").forEach {
            let amountOfColor = $0.split(separator: " ")
            colors[amountOfColor[1]] = Int(amountOfColor[0])
        }
        colors.forEach { color, amount in
            if maxColors[color, default: 0] < amount {
                maxColors[color] = amount
            }
        }
        if colors["red", default: 0] > 12 || colors["green", default: 0] > 13 || colors["blue", default: 0] > 14 {
            isPossible = false
        }
    }
    sumOfMaxColors += maxColors.values.reduce(1, *)
    if isPossible {
        sumOfIds += game
    }
}
print(sumOfMaxColors)
print(sumOfIds)
