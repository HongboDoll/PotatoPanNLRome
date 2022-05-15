#!/bin/bash

rm -rf clustered_results; mkdir clustered_results
rm clustered_NLR.stat.xls
ls nlr_gff3/ | while read i
do
    name=`echo $i | awk -F '.' '{print $1}'`
    nlr_num=`cat nlr_gff3/${i} | awk '$3=="mRNA"' | wc -l`
    cat nlr_gff3/${i}|awk '$3=="mRNA"'|awk '{print $NF}'|awk -F ';' '{print $1}' |awk -F '=' '{print $2}' | while read nlr
    do
        nlr_type=`echo $nlr | awk -F '_' '{print $NF}'`
        chr=`cat nlr_gff3/${i} | awk '$3=="mRNA"' | grep $nlr | awk '{print $1}'`
        start=`cat nlr_gff3/${i} | awk '$3=="mRNA"' | grep $nlr | awk '{print $4}'`
        end=`cat nlr_gff3/${i} | awk '$3=="mRNA"' | grep $nlr | awk '{print $5}'`
        echo -e "${chr}\t${start}\t${end}\t${nlr}\t${nlr_type}" >> clustered_results/${name}.clustered.bed
	done
	sort -k1,1 -k2,2n clustered_results/${name}.clustered.bed -o clustered_results/${name}.clustered.bed
    python3 x.get_cluster.py clustered_results/${name}.clustered.bed clustered_results/${name}.clustered.txt
    cluster_num=`awk '$4!=2' clustered_results/${name}.clustered.txt | awk '{i+=$4}END{print i}'`
    echo -e "${name}\t${cluster_num}\t${nlr_num}" >> clustered_NLR.stat.xls
done

