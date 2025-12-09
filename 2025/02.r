#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")
input = scan(gsub('r$', 'input', this.path()), what="", sep=",")
# input = scan(text="11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124", what="", sep=",")
result1 = 0
result2 = 0

ranges = lapply(strsplit(input, "-"), as.double)
invalididfor = function(i) i + i * (10 ^ nchar(i))
invalidid2for = function(i, x) sum(unlist(lapply(0:(x-1), function(j) i * (10 ^ (j * nchar(i))))))

for (i in 1:length(input)) {
    range = unlist(ranges[i])
    # faster result1
    # nchars = nchar(range[1])
    # iterator = ifelse(nchars %% 2 == 0, floor(range[1] / 10 ^ ceiling(nchars/2)), 10 ^ floor(nchars/2))
    iterator = 1
    invalidid = invalididfor(iterator)
    foundinvalidids = c()
    while (invalidid <= range[2]) {
        if (invalidid >= range[1]) result1 = result1 + invalidid
        # result2
        for (length in which(1:(nchar(range[2]) %/% nchar(iterator)) > 1)) {
            invalidid2 = invalidid2for(iterator, length)
            if (invalidid2 >= range[1] && invalidid2 <= range[2] && !is.element(invalidid2, foundinvalidids)) {
                foundinvalidids = append(foundinvalidids, invalidid2)
                result2 = result2 + invalidid2
            }
        }
        iterator = iterator + 1
        invalidid = invalididfor(iterator)
    }
}

paste("part1", result1, result1 == 30599400849)
paste("part2", result2, result2 == 46270373595)
paste("elapsed time in seconds:", Sys.time() - start)
