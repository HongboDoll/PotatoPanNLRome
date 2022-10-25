#!/bin/bash

#./output_clades12_34_num.py 52_potato_matrix_core_dispensable_genes.cluster.copyNumber.xls potato_wild_species.xls num_clades12 num_clades34
#
#source activate r-4.1
#rm -rf results p_values; mkdir results
#grep -v 'Copy number' 52_potato_matrix_core_dispensable_genes.cluster.copyNumber.xls | while read i
#do
#	og=`echo $i | awk '{print $1}'`
#    cat num_clades12 | while read n
#    do
#        og=`echo $i | awk '{print $1}'`
#        echo $i | awk -v a=$n '{print $a}' >> results/${og}_clades12
#    done
#    cat num_clades34 | while read n
#    do
#        og=`echo $i | awk '{print $1}'`
#        echo $i | awk -v a=$n '{print $a}' >> results/${og}_clades34
#    done
#    paste results/${og}_clades34  results/${og}_clades12 > results/${og}
#    p=`./wilcox_test.R results/${og} | awk '{print $2}'`
#    echo -e "${og}\t${p}" >> p_values
#done
#
#awk '{print $1}' p_values > og_list
#./fdr.R p_values fdr.xls
#paste og_list fdr.xls > og_fdr.xls
#
#cat p_values | awk '$2<0.01' > og_expanded_p0.01
#
#rm og_expanded_p0.01_copy_number.xls
#cat og_expanded_p0.01 |awk '{print $1}'|while read i
#do
#    awk '{i+=$1;j+=$2}END{print "'"$i"'",i/20,j/6}' results/${i} >> og_expanded_p0.01_copy_number.xls
#done
#
######### clades12 expanded OGs
#rm clades12_expanded_OG.xls
#cat og_expanded_p0.01_copy_number.xls|awk '$3>=$2' | awk '{print $1}'| while read i
#do
#    grep $i 52_potato_matrix_core_dispensable_genes.cluster >> clades12_expanded_OG.xls
#done
#
#cat <(head -1 52_potato_matrix_core_dispensable_genes.cluster) clades12_expanded_OG.xls > t && mv t clades12_expanded_OG.xls
#
#
########## clades12 contracted OGs
#rm clades12_contracted_OG.xls
#cat og_expanded_p0.01_copy_number.xls|awk '$3<=$2'| awk '{print $1}'| while read i
#do
#    awk '$1=="'"$i"'"' 52_potato_matrix_core_dispensable_genes.cluster >> clades12_contracted_OG.xls
#done
#
#cat <(head -1 52_potato_matrix_core_dispensable_genes.cluster) clades12_contracted_OG.xls > t && mv t clades12_contracted_OG.xls
#
######## clades 12, clades 34, cando, landrace NLRs in the 31 conatracted OGs
#cat clades12_contracted_OG.xls |cut -f '7,16,24,30'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_contracted_OG_clades12_NLR.xls
#
#cat clades12_contracted_OG.xls |cut -f '3,4,5,6,8,9,10,17,18,19,20,21,22,23,25,27,28,29,31,32,54'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_contracted_OG_clades34_NLR.xls
#
#cat clades12_contracted_OG.xls |cut -f '11,12,13,14,15'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_contracted_OG_cando_NLR.xls
#
#cat clades12_contracted_OG.xls |cut -f '33,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_contracted_OG_landrace_NLR.xls

####### extract corresponding genomic coordinates with 5-kb left right flanking

#for i in clades12 clades34 cando landrace
#do
#    rm clades12_contracted_OG_${i}_NLR_coordinates.xls
#    cat clades12_contracted_OG_${i}_NLR.xls | while read g
#    do
#        grep $g 52_potato_NLR_annotation.gff3 | awk 'BEGIN{OFS="\t"}{if($4-5000<0){print $1,0,$5+5000}else{print $1,$4-5000,$5+5000}}' >> clades12_contracted_OG_${i}_NLR_coordinates.xls
#    done
#    sort -k1,1 -k2,2n clades12_contracted_OG_${i}_NLR_coordinates.xls -o clades12_contracted_OG_${i}_NLR_coordinates.xls
#    bedtools merge -i clades12_contracted_OG_${i}_NLR_coordinates.xls > t && mv t clades12_contracted_OG_${i}_NLR_coordinates.xls
#done

#cat h <(paste <(awk '{print $1}' tt) <(awk '{print "NA"}' tt) <(cut -f '2-99' tt)) > clades12_not_contracted_OG.xls

######## clades 12, clades 34, cando, landrace NLRs in the 458 non-conatracted OGs
#cat clades12_not_contracted_OG.xls |cut -f '7,16,24,30'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_not_contracted_OG_clades12_NLR.xls
#
#cat clades12_not_contracted_OG.xls |cut -f '3,4,5,6,8,9,10,17,18,19,20,21,22,23,25,27,28,29,31,32,54'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_not_contracted_OG_clades34_NLR.xls
#
#cat clades12_not_contracted_OG.xls |cut -f '11,12,13,14,15'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_not_contracted_OG_cando_NLR.xls
#
#cat clades12_not_contracted_OG.xls |cut -f '33,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53'| sed 's/\t/\n/g'|sed 's/,/\n/g' |grep Solanum_ > clades12_not_contracted_OG_landrace_NLR.xls

####### extract corresponding genomic coordinates with 5-kb left right flanking

#for i in clades12 clades34 cando landrace
#do
#    rm clades12_not_contracted_OG_${i}_NLR_coordinates.xls
#    cat clades12_not_contracted_OG_${i}_NLR.xls | while read g
#    do
#        grep $g 52_potato_NLR_annotation.gff3 | awk 'BEGIN{OFS="\t"}{if($4-5000<0){print $1,0,$5+5000}else{print $1,$4-5000,$5+5000}}' >> clades12_not_contracted_OG_${i}_NLR_coordinates.xls
#    done
#    sort -k1,1 -k2,2n clades12_not_contracted_OG_${i}_NLR_coordinates.xls -o clades12_not_contracted_OG_${i}_NLR_coordinates.xls
#    bedtools merge -i clades12_not_contracted_OG_${i}_NLR_coordinates.xls > t && mv t clades12_not_contracted_OG_${i}_NLR_coordinates.xls
#done

########## contracted vs non-contracted LTR Copia Gypsy unknown content

#cat /public/agis/huangsanwen_group/lihongbo/work/solanaceae_project/2021_8_23_luyao/edta/*.TEanno.gff3 | grep LTR/Copia|grep -v Parent | awk 'BEGIN{OFS="\t"}{print $1,$4,$5}' | sort -k1,1 -k2,2n > 52_potato_LTRCopia_coordinates.bed
#cat /public/agis/huangsanwen_group/lihongbo/work/solanaceae_project/2021_8_23_luyao/edta/*.TEanno.gff3 | grep LTR/Gypsy|grep -v Parent | awk 'BEGIN{OFS="\t"}{print $1,$4,$5}' | sort -k1,1 -k2,2n > 52_potato_LTRGypsy_coordinates.bed
#cat /public/agis/huangsanwen_group/lihongbo/work/solanaceae_project/2021_8_23_luyao/edta/*.TEanno.gff3 | grep LTR/unknown|grep -v Parent | awk 'BEGIN{OFS="\t"}{print $1,$4,$5}' | sort -k1,1 -k2,2n > 52_potato_LTRunknown_coordinates.bed


for i in clades12 clades34 cando landrace
do
    echo -e "$i"
    for l in Copia Gypsy unknown
    do
        sort -k1,1 -k2,2n clades12_contracted_OG_${i}_NLR_coordinates.xls -o clades12_contracted_OG_${i}_NLR_coordinates.xls
        sort -k1,1 -k2,2n clades12_not_contracted_OG_${i}_NLR_coordinates.xls -o clades12_not_contracted_OG_${i}_NLR_coordinates.xls
		echo -e "${l}_contracted\t\c"
        awk '{print $1}' clades12_contracted_OG_${i}_NLR_coordinates.xls | awk -F '_' '{print $1}' | sort | uniq | while read c
        do
            grep ${c}_ clades12_contracted_OG_${i}_NLR_coordinates.xls > tmp
			total=`awk '{i+=($3-$2+1)}END{print i}' tmp`
            length=`bedtools intersect -a tmp -b 52_potato_LTR${l}_coordinates.bed | awk '{i+=($3-$2+1)}END{print i}'`
			percentage=`echo "scale=4;$length/$total*100"|bc`
            echo -e "${percentage}\t\c"
        done
        echo -e ""
		echo -e "${l}_non-contracted\t\c"
        awk '{print $1}' clades12_not_contracted_OG_${i}_NLR_coordinates.xls | awk -F '_' '{print $1}' | sort | uniq | while read c
        do
            grep ${c}_ clades12_not_contracted_OG_${i}_NLR_coordinates.xls > tmp
			total=`awk '{i+=($3-$2+1)}END{print i}' tmp`
            length=`bedtools intersect -a tmp -b 52_potato_LTR${l}_coordinates.bed | awk '{i+=($3-$2+1)}END{print i}'`
			percentage=`echo "scale=4;$length/$total*100"|bc`
            echo -e "${percentage}\t\c"
        done
        echo -e ""
    done
done

#rm amr3_clade06_keep_C509_S_chacoense.xls
#cat amr3_clade06_keep.xls | while read i
#do
#    awk '{print $16,$17}' DM_51_potato_genetribe_one2one_matrix.xls | grep $i >> amr3_clade06_keep_C509_S_chacoense.xls
#done
