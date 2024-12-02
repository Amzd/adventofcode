#!/usr/bin/env swift

import Foundation
import RegexBuilder

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result1 = 0
var result2 = 0

func getFirstInvalidOffsets(_ numbers: [Int]) -> [Int] {
    let firstNotDecreasing = numbers.enumerated().first { offset, number in
        numbers.indices.contains(offset + 1) && !(1...3 ~= number - numbers[offset + 1])
    }
    let firstNotIncreasing = numbers.enumerated().first { offset, number in
        numbers.indices.contains(offset + 1) && !(1...3 ~= -(number - numbers[offset + 1]))
    }
    return [firstNotDecreasing, firstNotIncreasing].compactMap(\.?.offset)
}
for line in input.split(separator: "\n") {
    let numbers = line.split(separator: " ").map(String.init).compactMap(Int.init)
    let firstInvalidOffsets = getFirstInvalidOffsets(numbers)
    if firstInvalidOffsets.count < 2 {
        result1 += 1
        result2 += 1
    } else if firstInvalidOffsets.map({ getFirstInvalidOffsets(numbers.removing(at: $0 + 1)) }).contains(where: { $0.count < 2 }) {
        result2 += 1
    } else if firstInvalidOffsets.map({ getFirstInvalidOffsets(numbers.removing(at: $0)) }).contains(where: { $0.count < 2 }){
        result2 += 1
    }

}

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)

extension Array {
    func removing(at: Int) -> Self {
        guard indices.contains(at) else { return self }
        var copy = self
        copy.remove(at: at)
        return copy
    }
}
