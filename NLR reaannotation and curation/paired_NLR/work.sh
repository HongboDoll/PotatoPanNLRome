#!/bin/bash

rm -rf paired_results; mkdir paired_results
rm paired_NLR.stat.xls
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
        echo -e "${chr}\t${start}\t${end}\t${nlr}\t${nlr_type}" >> paired_results/${name}.paired.bed
	done
	sort -k1,1 -k2,2n paired_results/${name}.paired.bed -o paired_results/${name}.paired.bed
    python3 x.get_paired_NBS.py nlr_gff3/${i} paired_results/${name}.paired.bed paired_results/${name}.paired.txt
    paired_num=`grep -v '#' paired_results/${name}.paired.txt | awk '{print NR*2}' | tail -1`
    echo -e "${name}\t${paired_num}\t${nlr_num}" >> paired_NLR.stat.xls

done

####### remove paried NLRs from clustered NLRs
rm paired_NLR.stat.xls
ls nlr_gff3/ | while read i
do
    name=`echo $i | awk -F '.' '{print $1}'`
    ./filter_pairedNLR_from_cluster.py paired_results/${name}.paired.txt ../clustered_NLR/clustered_results/${name}.clustered.txt > paired_results/${name}.paired.filter.txt
	nlr_num=`cat nlr_gff3/${i} | awk '$3=="mRNA"' | wc -l`
	paired_num=`grep -v '#' paired_results/${name}.paired.filter.txt | awk '{print NR*2}' | tail -1`
	echo -e "${name}\t${paired_num}\t${nlr_num}" >> paired_NLR.stat.xls
done



