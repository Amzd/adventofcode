#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")
input = read.table(gsub('r$', 'input', this.path()), header = FALSE)

result1 = sum(abs(sort(input[,1]) - sort(input[,2])))

result2 = 0
for (lhs in input[,1]) {
    result2 = result2 + lhs * length(input[,2][input[,2] == lhs])
}

paste("part1", result1, result1 == 1258579)
paste("part2", result2, result2 == 23981443)
paste("elapsed time in seconds:", Sys.time() - start)
