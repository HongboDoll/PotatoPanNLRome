#!/usr/bin/env Rscript

argv<-commandArgs(TRUE)
d <- read.table(argv[1],header=F,fill=T)

x <- d$V1
y <- d$V2

library(exactRankTests)
d <- wilcox.exact(x,y)
d$p.value

