#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")
input = read.delim(gsub('r$', 'input', this.path()))
result1 = 0
result2 = 0

# TODO: Good luck

paste("part1", result1, result1 == 0)
paste("part2", result2, result2 == 0)
paste("elapsed time in seconds:", Sys.time() - start)
