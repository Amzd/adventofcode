# Advent of Code

Every <day>.swift file is a script without dependencies that can be run with `./<year>/<day>.swift`.

To start a new day run `./startday.swift <day> [year]`. The startday script requires [swift-sh](https://github.com/mxcl/swift-sh).

To compare performance run `./runcompiled.swift <path to swift file> [wether to also run JIT]`.

- Note: After updating Swift version you need to run `swift-sh --clean-cache startday.swift && swift-sh --clean-cache runcompiled.swift`


## R

R scripts can be ran the same as swift files, with `./<year>/<day>.r`.

Install the `this.path` dependency using:
```
Rscript -e 'install.packages("this.path", repos="https://cloud.r-project.org")'
```
