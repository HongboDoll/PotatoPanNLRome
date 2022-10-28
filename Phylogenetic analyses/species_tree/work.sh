#!/bin/bash

source activate /home/jiayuxin/anaconda3/envs/ortho

orthofinder -f pep -a 52 -t 52 -T iqtree -M msa  -os

source /home/huyong/software/anaconda3/bin/activate collinerity

rm -rf mafft_out_pep; mkdir mafft_out_pep
ls $PWD/pep/OrthoFinder/Results_Mar06/Single_Copy_Orthologue_Sequences | while read i
do
	mafft --thread 52 --auto $PWD/pep/OrthoFinder/Results_Mar06/Single_Copy_Orthologue_Sequences/${i} > mafft_out_pep/${i}.out
	fa2phy.py -i mafft_out_pep/${i}.out -o mafft_out_pep/${i}.phylip
	awk 'NR!=1' mafft_out_pep/${i}.phylip | awk '{print $2}' > t && mv t mafft_out_pep/${i}.phylip
done

head -1 pep/OrthoFinder/Results_*/Orthogroups/Orthogroups.tsv | sed 's/\t/\n/g' | awk 'NR!=1' > first_col
n=`ls mafft_out_pep/*.phylip | sed ':a;N;s/\n/ /g;ta'`
paste -d '' $n > mafft_out_pep/GR.phylip.all
awk 'BEIGN{n=1}{print ">"n"\n"$1;n+=1}' mafft_out_pep/GR.phylip.all > mafft_out_pep/GR.phylip.all.fa
####./remove_gap_N_in_fasta_alignment.py mafft_out_pep/GR.phylip.all.fa  mafft_out_pep/GR.phylip.all.noGAP.fa
n1=`grep -v '>' mafft_out_pep/GR.phylip.all.fa | wc -l | awk '{print $1}'`
n2=`sed 's/ //g' mafft_out_pep/GR.phylip.all.fa | grep -v '>' | head -1 |wc | awk '{print $3-1}'`
echo -e "$n1 $n2" > mafft_out_pep/head
cat mafft_out_pep/head <(paste -d '\t' first_col  <(grep -v '>' mafft_out_pep/GR.phylip.all.fa)) | sed 's/\t/            /g' > single_copy_gene_family_pep_4_tree.phylip
#

iqtree -s single_copy_gene_family_pep_4_tree.phylip -m MFP -safe -T 52
iqtree -s single_copy_gene_family_pep_4_tree.phylip -m JTT+F+R5 -b 100 -nt AUTO -ntmax 52
