#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

let scanner = Scanner(string: input)

while !scanner.isAtEnd {
    _ = scanner.scanString("Button A: X+")
    let aX = scanner.scanInt()!
    _ = scanner.scanString(", Y+")
    let aY = scanner.scanInt()!
    _ = scanner.scanString("Button B: X+")!
    let bX = scanner.scanInt()!
    _ = scanner.scanString(", Y+")
    let bY = scanner.scanInt()!
    _ = scanner.scanString("Prize: X=")
    let prizeX = scanner.scanInt()!
    _ = scanner.scanString(", Y=")
    let prizeY = scanner.scanInt()!
    _ = scanner.scanString("\n")


    func minPossible(_ prizeX: Int, _ prizeY: Int) -> Int {
        let a = (prizeY * bX - prizeX * bY) / (aY * bX - aX * bY)
        let b = (prizeX - a * aX) / bX

        if prizeX == b * bX + a * aX && prizeY == b * bY + a * aY {
            return a * 3 + b
        } else {
            return 0
        }
    }

    result1 += minPossible(prizeX, prizeY)
    result2 += minPossible(prizeX + 10000000000000, prizeY + 10000000000000)
}

print("part1", result1, result1 == 29023)
print("part2", result2, result2 == 96787395375634)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
