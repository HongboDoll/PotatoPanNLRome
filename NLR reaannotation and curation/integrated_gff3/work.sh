#!/bin/bash

ls genome_gff3 | while read i
do
    name=`echo $i | awk -F '.' '{print $1}'`
    bedtools subtract -A -a genome_gff3/${i} -b nlr_gff3/${name}.filter.NLR.rename.gff3 > tmp.gff3
    cat tmp.gff3 nlr_gff3/${name}.filter.NLR.rename.gff3 > ${name}.integratedNLR.gff3
done