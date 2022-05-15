#!/bin/bash

source activate r-4.1
rm -rf results p_values; mkdir results
grep -v 'Orthogroup' Orthogroups.GeneCount.tsv | while read i
do
	og=`echo $i | awk '{print $1}'`
    cat num_potato | while read n
    do
        og=`echo $i | awk '{print $1}'`
        echo $i | awk -v a=$n '{print $a}' >> results/${og}_potato
    done
    cat num_tomato | while read n
    do
        og=`echo $i | awk '{print $1}'`
        echo $i | awk -v a=$n '{print $a}' >> results/${og}_tomato
    done
    paste results/${og}_potato  results/${og}_tomato > results/${og}
    p=`./wilcox_test.R results/${og} | awk '{print $2}'`
    echo -e "${og}\t${p}" >> p_values
done

awk '{print $1}' p_values > og_list
./fdr.R p_values fdr.xls
paste og_list fdr.xls > og_fdr.xls

cat og_fdr.xls |awk '$2<0.001' > og_expanded_fdr0.001

rm expanded_OG.xls
awk '{print $1}' og_expanded_fdr0.001 | while read i
do
    awk '$1=="'"$i"'"' 52_potato_9_tomato_OG.xls >> expanded_OG.xls
done

cat <(head -1 52_potato_9_tomato_OG.xls) expanded_OG.xls > t && mv t expanded_OG.xls
	

