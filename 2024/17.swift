#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
var result2 = 10000000

let inputSplit = input.split(separator: "\n\n")
let operandSplit = inputSplit[0].split(separator: "\n").map { $0.split(separator: ": ").last.map(String.init).map(Int.init)!! }

func run(_ inputInstructions: [Int], regA: Int?) -> [Int] {
    let search = regA != nil
    var regA = regA ?? operandSplit[0]
    var regB = operandSplit[1]
    var regC = operandSplit[2]
    var pointer = 0
    var outputs = [Int]()
    let instructions: [(Int) -> Void] = [
        { regA /= Int(pow(2, Double(combo($0)))) },
        { regB ^= $0 },
        { regB = combo($0) % 8 },
        { if regA != 0 { pointer = $0 } },
        { _ in regB ^= regC },
        { outputs.append(combo($0) % 8) },
        { regB = regA / Int(pow(2, Double(combo($0)))) },
        { regC = regA / Int(pow(2, Double(combo($0)))) },
    ]
    /// Get literal value from combo value
    func combo(_ operand: Int) -> Int {
        switch operand {
        case 0,1,2,3: operand
        case 4: regA
        case 5: regB
        case 6: regC
        default: fatalError()
        }
    }

    while pointer < inputInstructions.count - 1 {
        let prevPointer = pointer
        instructions[inputInstructions[pointer]](inputInstructions[pointer + 1])
        if prevPointer == pointer {
            pointer += 2
        }
        if search && !inputInstructions.starts(with: outputs) {
            return outputs
        }
    }

    return outputs
}



let inputInstructions = inputSplit[1]
    .replacingOccurrences(of: "Program: ", with: "")
    .replacingOccurrences(of: "\n", with: "")
    .split(separator: ",")
    .map { Int(String($0)) ?? {fatalError("'\($0)'")}($0) }

let result1 = run(inputInstructions, regA: nil).map(String.init).joined(separator: ",")


while run(inputInstructions, regA: result2) != inputInstructions {
    if result2 % 100 == 0 { print("iteration", result2) }
    result2 += 1
}


print("part1", result1, result1 == "1,5,7,4,1,6,0,3,0")
print("part2", result2, result2 == 0)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
