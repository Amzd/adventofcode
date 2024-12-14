#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result2 = 0
let width = 101
let height = 103
let seconds = 100

var countPerQuadrant = [0, 0, 0, 0]
var robots: [(XY, XY)] = []
for line in input.split(separator: "\n") {
    let pv = line.split(separator: " ")
    let p = pv[0].replacingOccurrences(of: "p=", with: "").split(separator: ",")
    let (startX, startY) = (Int(p[0])!, Int(p[1])!)
    let v = pv[1].replacingOccurrences(of: "v=", with: "").split(separator: ",")
    let (vX, vY) = (Int(v[0])!, Int(v[1])!)
    robots.append((XY(x: startX, y: startY), XY(x: vX, y: vY)))

    let finishX = nonNegativeModulo(of: startX + vX * seconds, by: width)
    let finishY = nonNegativeModulo(of: startY + vY * seconds, by: height)
    if let quadrantX = finishX == width/2 ? nil : finishX < width/2 ? 0 : 1,
       let quadrantY = finishY == height/2 ? nil : finishY < height/2 ? 0 : 1 {
        let quadrantIndex = quadrantX + quadrantY * 2
        countPerQuadrant[quadrantIndex] += 1
    }
}

// This sucked, I'm not making it better
var count = 0
whileLoop: while count <= 7584 + 1 {
    count += 1
    robots = robots.map { (XY(x: nonNegativeModulo(of: $0.x + $1.x, by: width), y: nonNegativeModulo(of: $0.y + $1.y, by: height)), $1) }
    let map = Dictionary(grouping: robots, by: \.0)
    let stem = (5..<height-5).compactMap { y in
        map[XY(x: width/2, y: y)]
    }
    if stem.count < 12 {
        continue whileLoop
    }
    for y in 0..<height {
        let row = (0..<width).map { x in
            map[.init(x: x, y: y)].map { String($0.count)} ?? " "
        }
        print(row.joined())
    }
    if readLine(strippingNewline: true).map(NSString.init)?.boolValue == true {
        result2 = count
        break
    }
}

struct XY: Hashable {
    let x, y: Int
}

@inlinable func nonNegativeModulo(of lhs: Int, by rhs: Int) -> Int {
    let result = lhs % rhs
    return result >= 0 ? result : result + rhs
}

let result1 = countPerQuadrant.reduce(1, *)
print("part1", result1, result1 == 0)
print("part2", result2, result2 == 7584)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
