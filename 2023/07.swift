#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

let cardValues: [Character] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"].reversed()
let cardValuesJoker: [Character] = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"].reversed()

struct Hand {
    var bid: Int
    var cardsSortValue: String

    init(hand: Substring, bid: Substring, countJokers: Bool = false) {
        self.bid = Int(bid)!

        var countPerCard = Dictionary(grouping: hand, by: \.self).mapValues(\.count)
        if countJokers && countPerCard.keys.count > 1,
           let jokersCount = countPerCard.removeValue(forKey: "J"),
           let highest = countPerCard.sorted(by: { $0.value > $1.value }).first?.key {
            countPerCard[highest, default: 0] += jokersCount
        }

        let handValue = switch countPerCard.values.sorted(by: >) {
        case [5]: 7
        case [4,1]: 6
        case [3,2]: 5
        case [3,1,1]: 4
        case [2,2,1]: 3
        case [2,1,1,1]: 2
        case [1,1,1,1,1]: 1
        default: fatalError()
        }

        let cardValues = countJokers ? cardValuesJoker : cardValues
        self.cardsSortValue = String(format: "%d%02d%02d%02d%02d%02d", arguments: [handValue] + hand.compactMap(cardValues.firstIndex))
    }
}

let inputSplit = input.split(separator: "\n").map { $0.split(separator: " ") }
let result1 = inputSplit
    .map { Hand(hand: $0[0], bid: $0[1], countJokers: false) }
    .sorted(using: [KeyPathComparator(\Hand.cardsSortValue)])
    .enumerated()
    .map { $0.element.bid * ($0.offset+1) }
    .reduce(0, +)
let result2 = inputSplit
    .map { Hand(hand: $0[0], bid: $0[1], countJokers: true) }
    .sorted(using: [KeyPathComparator(\Hand.cardsSortValue)])
    .enumerated()
    .map { $0.element.bid * ($0.offset+1) }
    .reduce(0, +)

print("part1", result1, result1 == 246163188)
print("part2", result2, result2 == 245794069)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)

extension Bool: @retroactive Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs == false && rhs == true
    }
}
