#!/bin/bash

source /home/huyong/software/anaconda3/bin/activate collinerity

rm -rf nonclade4_NLR_NB_seq nonclade4_NLR_distance; mkdir nonclade4_NLR_NB_seq nonclade4_NLR_distance
cat 52_potato_non-single-copy_clades.tsv4 | awk '{print $1}' | while read i
do
    grep $i 52_potato_non-single-copy_clades.tsv4 | sed 's/\t/\n/g' | sed 's/,/\n/g' | awk 'NR!=1' | grep '_NLR_' | while read g
    do
        give_me_one_seq.pl 52_potato_refplantNLR_NLR_NB-ARC_domain.fa $g >> nonclade4_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa
	done
    mafft --thread 52 --auto nonclade4_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa > nonclade4_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.out
    fa2phy.py -i nonclade4_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.out -o nonclade4_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.phylip
    raxmlHPC-PTHREADS-SSE3 -f a -x 5 -p 5 -# 100 -m PROTGAMMAJTT -s nonclade4_NLR_NB_seq/${i}_NLR_NB-ARC_domain.fa.phylip -n ${i}_NLR_NB-ARC_domain.fa -T 52
    ./phylogenetic_distance.py RAxML_bipartitions.${i}_NLR_NB-ARC_domain.fa > nonclade4_NLR_distance/${i}_NLR_phylogenetic_distance_matrix.xls
    cat <(echo -e $i) <(awk 'NR!=1' nonclade4_NLR_distance/${i}_NLR_phylogenetic_distance_matrix.xls | sed 's/ \+/\t/g' | cut -f '2-99999999' | sed 's/\t/\n/g') > nonclade4_NLR_distance/${i}_NLR_phylogenetic_distance_column.xls
done

#paste nonclade4_NLR_distance/*_NLR_phylogenetic_distance_column.xls nonclade4_NLR_distance/*_NLR_phylogenetic_distance_column.xls > 6_example_non_single_copy_NLR_clade_phylogenetic_distance_column.xls




