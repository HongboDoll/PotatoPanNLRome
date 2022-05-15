#!/usr/bin/env Rscript

argv<-commandArgs(TRUE)
d <- read.table(argv[1],header=F)

e <- p.adjust(d$V2,method='fdr',length(d$V2))

write.table(e,argv[2],row.names = FALSE,col.names = FALSE,quote = FALSE,sep='\n')

