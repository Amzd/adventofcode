#!/usr/bin/env swift-sh
import Foundation
import AsyncHTTPClient // swift-server/async-http-client

let day = CommandLine.arguments[safe: 1] ?? { fatalError("First argument should be day") }()
let year = CommandLine.arguments[safe: 2] ?? String(Calendar.current.component(.year, from: Calendar.current.date(byAdding: .month, value: -10, to: Date())!))
let dayString = day.count == 1 ? "0" + day : day
let inputFile = "\(year)/\(dayString).input"

let fm = FileManager.default
if !fm.fileExists(atPath: inputFile) {
    let token = ProcessInfo.processInfo.environment["AoC_token"] ?? { fatalError("set token in env as AoC_token") }()
    guard token.count > 0 else { fatalError("missing token") }

    print("Downloading input file")
    var request = try HTTPClient.Request(url: "https://adventofcode.com/\(year)/day/\(day)/input")
    request.headers.add(name: "Cookie", value: "session=\(token)")
    let delegate = try FileDownloadDelegate(path: inputFile)
    let result = try await HTTPClient.shared.execute(request: request, delegate: delegate).get()

    let contents = try String(contentsOfFile: inputFile)
    if result.totalBytes == nil {
        try? fm.removeItem(atPath: inputFile)
        print("Failed to download file")
        fatalError(contents)
    }
}

let templates = fm.enumerator(atPath: ".")?.compactMap { $0 as? String } .filter { $0.hasPrefix("template.") }
for template in templates ?? [] {
    let scriptFile = template.replacing("template", with: "\(year)/\(dayString)")
    if !fm.fileExists(atPath: scriptFile) {
        try fm.copyItem(atPath: template, toPath: scriptFile)
    }
}

#if os(Linux)
let openCommand = "xdg-open"
#else
let openCommand = "open"
#endif

print("Opening Browser")
let openBrowser = Process()
openBrowser.executableURL = URL(fileURLWithPath: "/usr/bin/env")
openBrowser.arguments = [openCommand, "https://adventofcode.com/\(year)/day/\(day)"]
try openBrowser.run()

print("Opening Editor")
let openEditor = Process()
openEditor.executableURL = URL(fileURLWithPath: "/usr/bin/env")
openEditor.arguments = ["gnome-terminal", "--", "zsh", "-c", "nvim \(year)/\(dayString).*"]
try? openEditor.run()

let scripts = fm.enumerator(atPath: year)?.compactMap { $0 as? String } .filter { $0.contains(dayString + ".") && !$0.hasSuffix(".input") }
for script in scripts ?? [] {
    print("Running `watch \(year)/\(script)`") // See https://github.com/Amzd/dotfiles/blob/main/.zshrc.d/aliases.zsh or the macos branch
    let watch = Process()
    watch.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    watch.arguments = ["zsh", "-c", "watch \(year)/\(script)"]
    // signal(SIGINT, { signal in watch.terminate() })
    // try watch.run()
    // watch.waitUntilExit()
}

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

func fatalError(_ msg: String) -> Never {
    print(msg)
    exit(1)
}
