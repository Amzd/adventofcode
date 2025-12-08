#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")
input = read.table(gsub('r$', 'input', this.path()), header = FALSE)
input$clicks = as.double(substring(input$V1, 2)) * ifelse(startsWith(input$V1, "L"), -1, 1)

result1 = 0
result2 = 0
dial = 50

for (i in 1:nrow(input)) {
    stride = input[i,]$clicks
    move = c(dial, dial + stride - trunc(stride / 100) * 100)
    fullrotations = abs(stride) %/% 100
    didpasszero = ifelse(stride < 0, move[2] <= 0 && move[1] != 0, move[2] >= 100)
    result2 = result2 + fullrotations + ifelse(didpasszero, 1, 0)
    dial = move[2] %% 100
    if (dial == 0) result1 = result1 + 1
}

paste("part1", result1, result1 == 1066)
paste("part2", result2, result2 == 6223)
paste("elapsed time in seconds:", Sys.time() - start)
