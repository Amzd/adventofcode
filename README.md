# Advent of Code

Every <Day>.swift file is a script without dependencies that can be run with `./<Day>.swift`.

To start a new day run `./startday.swift <day> [year]`. The startday script requires [swift-sh](https://github.com/mxcl/swift-sh).

To compare performance run `./runcompiled.swift <path to swift file> [wether to also run JIT]`.

- Note: After updating Swift version you need to run `swift-sh --clean-cache startday.swift && swift-sh --clean-cache runcompiled.swift`
