#!/usr/bin/env Rscript

start = Sys.time()
library("this.path")
input = read.table(gsub('r$', 'input', this.path()))
input = do.call(rbind, strsplit(input[,1], ""))
input = cbind(".",rbind(".",input,"."),".") # add empty neighbors around the data

removablerolls = function() {
    rolls = list()
    for (x in 2:nrow(input)) {
        for (y in 2:ncol(input)) {
            if (input[x, y] != "@") next
            count = 0
            for (dx in -1:1) for (dy in -1:1) if (dx != 0 || dy != 0)
                if (count < 4 && input[x + dx, y + dy] == "@") count = count + 1
            if (count < 4) rolls = append(rolls, list(c(x,y)))
        }
    }
    return(rolls)
}

removable = removablerolls()
result1 = length(removable)
result2 = 0
while(length(removable) > 0) {
    for (r in removable) input[r[1], r[2]] = "x"
    result2 = result2 + length(removable)
    removable = removablerolls()
}

paste("part1", result1, result1 == 1523)
paste("part2", result2, result2 == 9290)
paste("elapsed time in seconds:", Sys.time() - start)
