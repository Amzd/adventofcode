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

        return prizeX == b * bX + a * aX
            && prizeY == b * bY + a * aY
            ? a * 3 + b
            : 0;
    }

    result1 += minPossible(prizeX, prizeY)
    result2 += minPossible(prizeX + 10000000000000, prizeY + 10000000000000)
    // let correctedPrizeX = prizeX //+ 10000000000000
    // let correctedPrizeY = prizeY //+ 10000000000000
    // let (quotientX, _) = correctedPrizeX.quotientAndRemainder(dividingBy: bX) // + aX
    // let (quotientY, _) = correctedPrizeY.quotientAndRemainder(dividingBy: bY)
    // let bQuotient = min(quotientX, quotientY)
    // let remainderX = correctedPrizeX - bX * bQuotient
    // let remainderY = correctedPrizeY - bY * bQuotient
    // // print("prize", prizeX, prizeY, bQuotient, remainderX, remainderY)
    // for pressA in 0...100000000 {
    //     guard aX * pressA < correctedPrizeX, aY * pressA < correctedPrizeY else { break }
    //     // print("press", pressA, remainderX + bX * pressA, (remainderX + bX * pressA).quotientAndRemainder(dividingBy: aX))
    //     if case let (aQuotientX, 0) = (remainderX + bX * pressA).quotientAndRemainder(dividingBy: aX),
    //        case let (aQuotientY, 0) = (remainderY + bY * pressA).quotientAndRemainder(dividingBy: aY),
    //        aQuotientX == aQuotientY {
    //         result2 += aQuotientX * 3 + bQuotient - pressA
    //         break
    //     }
    // }
    // break
}


/// Returns the Greatest Common Divisor of two numbers.
func gcd(_ x: Int, _ y: Int, search: Int = 0) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)

    while r > search {
        a = b
        b = r
        r = a % b
    }
    return b
}

/// Returns the least common multiple of two numbers.
func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}

print("part1", result1, result1 == 29023)
print("part2", result2, result2 == 0)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
