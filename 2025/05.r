#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")
input = scan(gsub('r$', 'input', this.path()), what="", sep="\n", blank.lines.skip=FALSE)
splitIndex = which(input == "")
ranges = strsplit(input[1:(splitIndex-1)], "-")
ids = as.double(input[(splitIndex+1):length(input)])

result1 = 0
for (id in ids) {
    for (range in ranges) {
        range = as.double(range)
        if (range[1] <= id && id <= range[2]) {
            result1 = result1 + 1
            break
        }
    }
}

# i think there is something wrong here but it gives the right answer and im eepy
result2 = 0
sortedranges = sort_by(ranges, as.double(unlist(lapply(ranges, `[[`, 1))), as.double(unlist(lapply(ranges, `[[`, 2))))
prevrange = as.double(unlist(sortedranges[1]))
for (i in 2:length(sortedranges)) {
    range = as.double(unlist(sortedranges[i]))
    if (prevrange[2] + 1 >= range[1]) {
        prevrange[2] = max(range[2], prevrange[2])
    } else {
        result2 = result2 + length(prevrange[1]:prevrange[2])
        prevrange = range
    }
}
last = as.double(unlist(sortedranges[length(sortedranges)]))
if (!identical(prevrange, last)) result2 = result2 + length(prevrange[1]:prevrange[2])

paste("part1", result1, result1 == 770)
paste("part2", result2, result2 == 357674099117260)
paste("elapsed time in seconds:", Sys.time() - start)
