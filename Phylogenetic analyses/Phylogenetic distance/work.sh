#!/bin/bash

#rm Prf_tomato_potato_pep.fa
#cat Prf_tomato_potato_list.xls | while  read i
#do
#    give_me_one_seq.pl all_61_potato.faa $i >> Prf_tomato_potato_pep.fa
#done

source /home/huyong/software/anaconda3/bin/activate collinerity

#rm -rf clade_NLR_NB_seq clade_NLR_distance; mkdir clade_NLR_NB_seq clade_NLR_distance
#awk 'NR!=1' 52_potato_single-copy_clades.tsv | awk '{print $1}' | while read i
#do
#    grep $i 52_potato_single-copy_clades.tsv | sed 's/\t/\n/g' | sed 's/,/\n/g' | awk 'NR!=1' | grep '_NLR_' | while read g
#    do
#        give_me_one_seq.pl 52_potato_refplantNLR_NLR_NB-ARC_domain.fa $g >> clade_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa
#	done
#    mafft --thread 52 --auto clade_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa > clade_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.out
#    fa2phy.py -i clade_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.out -o clade_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.phylip
#    raxmlHPC-PTHREADS-SSE3 -f a -x 5 -p 5 -# 100 -m PROTGAMMAJTT -s clade_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.phylip -n ${i}_NLR_NB-ARC_domain.fa -T 52
#    ./phylogenetic_distance.py RAxML_bipartitions.${i}_NLR_NB-ARC_domain.fa > clade_NLR_distance/${i}_NLR_phylogenetic_distance_matrix.xls
#    cat <(echo -e $i) <(awk 'NR!=1' clade_NLR_distance/${i}_NLR_phylogenetic_distance_matrix.xls | sed 's/ \+/\t/g' | cut -f '2-99999999' | sed 's/\t/\n/g') > clade_NLR_distance/${i}_NLR_phylogenetic_distance_column.xls
#    done
#
#paste clade_NLR_distance/*_NLR_phylogenetic_distance_column.xls > 38_single_copy_NLR_clade_phylogenetic_distance_column.xls


cat <(grep Clade 10_example_non_single_copy_NLR_clade_phylogenetic_distance_column.xls) <(awk 'NF==38' 10_example_non_single_copy_NLR_clade_phylogenetic_distance_column.xls  |grep -v 'Clade'|shuf -n2000) > 38_single_copy_NLR_clade_phylogenetic_distance_column_random2000.xls

cat <(grep Clade 10_example_non_single_copy_NLR_clade_phylogenetic_distance_column.xls) <(awk 'NF==10' 10_example_non_single_copy_NLR_clade_phylogenetic_distance_column.xls  |grep -v 'Clade'|shuf -n2000) > 10_example_non_single_copy_NLR_clade_phylogenetic_distance_column_random2000.xls

paste 38_single_copy_NLR_clade_phylogenetic_distance_column_random2000.xls 10_example_non_single_copy_NLR_clade_phylogenetic_distance_column_random2000.xls > 38_single_copy_10_non_single_copy_NLR_clade_phylogenetic_distance_column_random2000.xls


######### Prf clade tree
i=Clade0000104

#rm ${i}_NLR_NB-ARC_domain.fa
#    grep $i 52_potato_single-copy_clades.tsv | sed 's/\t/\n/g' | sed 's/,/\n/g' | awk 'NR!=1' | grep '_NLR_' | while read g
#    do
#        give_me_one_seq.pl 52_potato_refplantNLR_NLR_NB-ARC_domain.fa $g >> ${i}_NLR_NB-ARC_domain.fa
#        done
#    cat ${i}_NLR_NB-ARC_domain.fa prf_tomato_Nb_NB-ARC_domain.fa > ${i}_prf_tomato_Nb_NLR_NB-ARC_domain.fa
#    mafft --thread 52 --auto ${i}_prf_tomato_Nb_NLR_NB-ARC_domain.fa > ${i}_prf_tomato_Nb_NLR_NB-ARC_domain.fa.out
#    fa2phy.py -i ${i}_prf_tomato_Nb_NLR_NB-ARC_domain.fa.out -o ${i}_prf_tomato_Nb_NLR_NB-ARC_domain.fa.phylip
    raxmlHPC-PTHREADS-SSE3 -f a -x 5 -p 5 -# 100 -m PROTGAMMAJTT -s ${i}_prf_tomato_Nb_NLR_NB-ARC_domain.fa.phylip -n ${i}_prf_tomato_Nb_NLR_NB-ARC_domain.fa -T 52
    
java -jar $li/bin/PareTree1.0.2.jar -t O -f RAxML_bipartitions.${i}_NLR_NB-ARC_domain.fa -del del.xls ### keep.xls 一行一个需要保留的序列

