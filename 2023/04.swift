#!/usr/bin/env swift

import Foundation
import RegexBuilder

let start = Date()
let input = try! String(contentsOfFile: "04.input")
var total = 0
var games = input.split(separator: "\n").map(Game.init)
let originalCount = games.count
var index = 0
while let game = index < games.count ? games[index] : nil {
    if index < originalCount {
        total += game.score
    }
    index += 1
    guard !game.winningNrs.isEmpty else { continue }
    for i in game.gameNr...game.gameNr + game.winningNrs.count - 1 where i < originalCount {
        games.append(games[i])
    }
}

print("part1", total)
print("part2", games.count)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)

struct Game {
    init(string: Substring) {
        self.gamesplit = string.split(separator: ":")
        self.gameNr = Int(gamesplit[0].matches(of: OneOrMore(.digit))[0].0)!
        self.split = gamesplit[1].split(separator: "|")
        self.winNrs = split[0].matches(of: OneOrMore(.digit)).compactMap { Int($0.0) }
        self.cardNrs = split[1].matches(of: OneOrMore(.digit)).compactMap { Int($0.0) }
        self.winningNrs = cardNrs.filter(winNrs.contains)
        self.score = Int(winningNrs.reduce(0.5, { current, _ in current * 2.0 }))
    }
    var gamesplit: [Substring]
    var gameNr: Int
    var split: [Substring]
    var winNrs: [Int]
    var cardNrs: [Int]
    var winningNrs: [Int]
    var score: Int
}
