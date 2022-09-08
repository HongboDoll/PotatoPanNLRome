#!/bin/bash

source activate /home/huyong/software/anaconda3/envs/R_Python
     
ls *gff3 | while read i
do
	name=`echo $i | awk -F '.' '{print $1}'`
	python -m jcvi.annotation.stats stats $i &> jcvi_stats  && mv jcvi_stats ${name}.stat1
    python -m jcvi.annotation.stats genestats ${i} &> jcvi_genestats && mv jcvi_genestats ${name}.stat2
    python -m jcvi.annotation.stats statstable ${i} &> jcvi_statstable && mv jcvi_statstable ${name}.stat3
	cat  ${name}.stat1 ${name}.stat2 ${name}.stat3 > ${name}.stat               
done


