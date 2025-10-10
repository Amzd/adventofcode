#!/usr/bin/env swift

import Foundation
import RegexBuilder

let input = try String(contentsOfFile: #file.replacingOccurrences(of: ".swift", with: ".input"))
//let input = """
//seeds: 79 14 55 13
//
//seed-to-soil map:
//50 98 2
//52 50 48
//
//soil-to-fertilizer map:
//0 15 37
//37 52 2
//39 0 15
//
//fertilizer-to-water map:
//49 53 8
//0 11 42
//42 0 7
//57 7 4
//
//water-to-light map:
//88 18 7
//18 25 70
//
//light-to-temperature map:
//45 77 23
//81 45 19
//68 64 13
//
//temperature-to-humidity map:
//0 69 1
//1 0 69
//
//humidity-to-location map:
//60 56 37
//56 93 4
//"""
let start = Date()
var result1 = 0
var result2 = 0

typealias Map = (source: Range<Int>, offset: Int)
func initMap(from string: Substring) -> Map {
    let ints = string.components(separatedBy: " ").compactMap { Int($0) }
    return (ints[1]..<ints[1]+ints[2], ints[0] - ints[1])
}

let scanner = Scanner(string: input)
_ = scanner.scanString("seeds: ")
let seeds = scanner.scanUpToString("\n\n")!.components(separatedBy: " ").compactMap { Int($0) }
_ = scanner.scanString("seed-to-soil map:\n")!
let seedToSoil = scanner.scanUpToString("\n\n")!.split(separator: "\n").map(initMap).sorted(using: [KeyPathComparator(\.source.lowerBound)])
_ = scanner.scanString("soil-to-fertilizer map:\n")!
let soilToFertilizer = scanner.scanUpToString("\n\n")!.split(separator: "\n").map(initMap).sorted(using: [KeyPathComparator(\.source.lowerBound)])
_ = scanner.scanString("fertilizer-to-water map:\n")!
let fertilizerToWater = scanner.scanUpToString("\n\n")!.split(separator: "\n").map(initMap).sorted(using: [KeyPathComparator(\.source.lowerBound)])
_ = scanner.scanString("water-to-light map:\n")!
let waterToLight = scanner.scanUpToString("\n\n")!.split(separator: "\n").map(initMap).sorted(using: [KeyPathComparator(\.source.lowerBound)])
_ = scanner.scanString("light-to-temperature map:\n")!
let lightToTemperature = scanner.scanUpToString("\n\n")!.split(separator: "\n").map(initMap).sorted(using: [KeyPathComparator(\.source.lowerBound)])
_ = scanner.scanString("temperature-to-humidity map:\n")!
let temperatureToHumidity = scanner.scanUpToString("\n\n")!.split(separator: "\n").map(initMap).sorted(using: [KeyPathComparator(\.source.lowerBound)])
_ = scanner.scanString("humidity-to-location map:\n")!
let humidityToLocation = scanner.scanUpToString("\n\n")!.split(separator: "\n").map(initMap).sorted(using: [KeyPathComparator(\.source.lowerBound)])

func getLocation(for seed: Int) -> Int {
    let soil = seedToSoil.first { $0.source.contains(seed) }.map { seed + $0.offset } ?? seed
    let fertilizer = soilToFertilizer.first { $0.source.contains(soil) }.map { soil + $0.offset } ?? soil
    let water = fertilizerToWater.first { $0.source.contains(fertilizer) }.map { fertilizer + $0.offset } ?? fertilizer
    let light = waterToLight.first { $0.source.contains(water) }.map { water + $0.offset } ?? water
    let temperature = lightToTemperature.first { $0.source.contains(light) }.map { light + $0.offset } ?? light
    let humidity = temperatureToHumidity.first { $0.source.contains(temperature) }.map { temperature + $0.offset } ?? temperature
    return humidityToLocation.first { $0.source.contains(humidity) }.map { humidity + $0.offset } ?? humidity
}
func getLocations(for seed: Range<Int>) -> [Range<Int>] {
    let soilRanges = split(range: seed, over: seedToSoil)
    let fertilizerRanges = soilRanges.flatMap { split(range: $0, over: soilToFertilizer) }
    let waterRanges = fertilizerRanges.flatMap { split(range: $0, over: fertilizerToWater) }
    let lightRanges = waterRanges.flatMap { split(range: $0, over: waterToLight) }
    let temperatureRanges = lightRanges.flatMap { split(range: $0, over: lightToTemperature) }
    let humidityRanges = temperatureRanges.flatMap { split(range: $0, over: temperatureToHumidity) }
    return humidityRanges.flatMap { split(range: $0, over: humidityToLocation) }
}
func split(range: Range<Int>, over ranges: [Map]) -> [Range<Int>] {
    var result = [Range<Int>]()
    var start = range.lowerBound
    while start < range.upperBound {
        if let next = ranges.first(where: { $0.source.contains(start) }) {
            result.append(start + next.offset..<min(range.upperBound, next.source.upperBound) + next.offset)
            start = next.source.upperBound
        } else {
            let min = min(ranges.first { $0.source.lowerBound > start}?.source.lowerBound ?? range.upperBound, range.upperBound)
            result.append(start..<min)
            start = min
        }
    }
    return result
}

result1 = seeds.map(getLocation).min()!

let seedRanges = stride(from: 0, to: seeds.count, by: 2).map {
    seeds[$0]..<seeds[$0]+seeds[$0+1]
}
result2 = seedRanges.flatMap(getLocations).map(\.lowerBound).min()!

print("part1", result1)
print("part2", result2)
print("elapsed time in seconds:", -start.timeIntervalSinceNow)
