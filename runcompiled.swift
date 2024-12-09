#!/usr/bin/env swift

import Foundation

let file = CommandLine.arguments.dropFirst(1).first ?? { fatalError("First argument should be file") }()
let showJIT = CommandLine.arguments.dropFirst(2).first.flatMap(NSString.init)?.boolValue ?? true
let executable = file.split(separator: ".").dropLast().joined()

guard file.hasSuffix(".swift") else { fatalError(" First arg is not a swift file") }

let fm = FileManager.default
guard !fm.fileExists(atPath: executable) else { fatalError("There is already a file at \(executable)") }

let compile = Process()
compile.executableURL = URL(fileURLWithPath: "/usr/bin/env")
compile.arguments = ["swiftc", file, "-o", executable, "-O", "-gnone", "-whole-module-optimization"]
try compile.run()
compile.waitUntilExit()

if showJIT {
    print("--- JIT:")

    let run = Process()
    run.executableURL = URL(fileURLWithPath: file)
    try? run.run()
    run.waitUntilExit()
}

print("--- compiled:")

let compiled = Process()
compiled.executableURL = URL(fileURLWithPath: executable)
try? compiled.run()
compiled.waitUntilExit()

try? fm.removeItem(atPath: executable)

func fatalError(_ msg: String) -> Never {
    print(msg)
    exit(1)
}
