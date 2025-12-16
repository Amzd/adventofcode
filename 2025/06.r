#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")

input = read.table(gsub('r$', 'input', this.path()))
result1 = 0
rows = nrow(input)
for (col in 1:ncol(input)) {
    rowsolution = as.double(input[1, col])
    for (row in 2:(rows-1)) {
        rowsolution = do.call(input[rows, col], list(rowsolution, as.double(input[row, col])))
    }
    result1 = result1 + rowsolution
}

input2 = readLines(gsub('r$', 'input', this.path()))
modifiers = unlist(strsplit(input2[length(input2)], " (?=[^ ]+)", perl=TRUE))
input2 = strsplit(input2, '')

getnumberat = function(column) as.double(paste(
    lapply(1:(length(input2)-1), function(j) unlist(input2[j])[column]),
    collapse=""
))

result2 = 0
offset = 0
for (modifier in modifiers) {
    modifierfun = unlist(strsplit(modifier, " "))[1]
    rowsolution = getnumberat(1 + offset)
    for (i in 2:nchar(modifier)) {
        rowsolution = do.call(modifierfun, list(rowsolution, getnumberat(i + offset)))
    }
    result2 = result2 + rowsolution
    offset = offset + nchar(modifier) + 1
}

paste("part1", result1, result1 == 6635273135233)
paste("part2", result2, result2 == 12542543681221)
paste("elapsed time in seconds:", Sys.time() - start)
