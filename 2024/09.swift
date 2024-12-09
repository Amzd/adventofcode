#!/usr/bin/env swift

import Foundation

let start = Date()
let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))

var diskmap: [Range<Int>] = []
for char in input where Int(String(char)) != nil {
    let num = Int(String(char))!
    let last = diskmap.last?.endIndex ?? 0
    diskmap.append(last..<num+last)
}
if diskmap.count.isMultiple(of: 2) {
    diskmap.removeLast()
}
let diskmapCopy = diskmap

var fileblocks: [Int] = []
for index in stride(from: 0, to: diskmap.count, by: 2) where index < diskmap.count {
    let block = diskmap[index]
    fileblocks.append(contentsOf: block.map { _ in index / 2 })
    if index < diskmap.count-1 {
        let empty = diskmap[index + 1]
        fileblocks.append(contentsOf: empty.map { _ in
            let endIndex = diskmap.endIndex
            guard endIndex > index + 1 else { return -1 }
            let dropLast = diskmap.popLast()!.dropLast()
            if dropLast.count > 0 {
                diskmap.append(dropLast.startIndex..<dropLast.endIndex)
            } else {
                // remove dangling empty
                diskmap.removeLast()
            }
            return (endIndex) / 2
        }.filter { $0 > 0 } )
    }
}

diskmap = diskmapCopy
let diskmapCount = diskmap.map(\.count).reduce(0, +)
var wholefileblocks: [Int] = (diskmap.first!.startIndex..<diskmapCount).map { _ in 0 }
for index in stride(from: 0, to: diskmap.count, by: 2) {
    wholefileblocks.replaceSubrange(diskmap[index], with: diskmap[index].map { _ in index/2})
}
for index in stride(from: diskmap.endIndex - 1, to: 1, by: -2) where diskmap[index].count > 0 {
    let block = diskmap[index]
    if let emptyIndex = stride(from: 1, to: index, by: 2).first(where: { diskmap[$0].count >= block.count }) {
        let emptyBlock = diskmap[emptyIndex]
        let write = emptyBlock.startIndex..<emptyBlock.startIndex + block.count
        wholefileblocks.replaceSubrange(write, with: block.map { _ in index/2 })
        wholefileblocks.replaceSubrange(block, with: block.map { _ in 0 })
        diskmap[emptyIndex] = min(emptyBlock.startIndex + block.count, emptyBlock.endIndex)..<emptyBlock.endIndex
    }
}

print("part1", fileblocks.enumerated().map(*).reduce(0, +), "6283170117911")
print("part2", wholefileblocks.enumerated().map(*).reduce(0, +), "6307653242596")
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
