#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")
input = scan(gsub('r$', 'input', this.path()), what="", sep="\n")
result1 = 0
result2 = 0

highestnr = function(str, nrofdigits) {
    if (nrofdigits < 1) return(0)
    strnchar = nchar(str)
    withoutLast = substring(str, 1, strnchar - nrofdigits + 1)
    withoutLastSplit = as.double(unlist(strsplit(withoutLast, split='')))
    maxIndex = which.max(withoutLastSplit)
    nextMax = highestnr(substring(str, maxIndex + 1, strnchar), nrofdigits - 1)
    return(withoutLastSplit[maxIndex] * (10 ^ (nrofdigits - 1)) + nextMax)
}

for (row in input) {
    result1 = result1 + highestnr(row, 2)
    result2 = result2 + highestnr(row, 12)
}

paste("part1", result1, result1 == 17196)
paste("part2", result2, result2 == 171039099596062)
paste("elapsed time in seconds:", Sys.time() - start)
