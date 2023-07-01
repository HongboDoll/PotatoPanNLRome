#!/bin/bash

for i in C400 C509 C534 C555 C672 C850 C871
do
hifiasm --primary -t 52 ${i}.ccs.fasta.gz -o ${i}

awk '/^S/{print ">"$2;print $3}' ${i}.p_ctg.gfa > ${i}.p_ctg.fasta 

seq_n50.pl ${i}.p_ctg.fasta > ${i}.p_ctg.fasta.n50

minimap2 -t 40 -x map-pb ${i}.p_ctg.fasta ${i}.ccs.fasta.gz > ${i}_aln.paf
pbcstat ${i}_aln.paf
calcuts PB.stat > cutoffs
split_fa ${i}.p_ctg.fasta > ${i}_split.fa
minimap2 -xasm5 -DP -t 40 ${i}_split.fa ${i}_split.fa > ${i}_split_self_aln.paf
purge_dups -2 -T cutoffs -c PB.base.cov ${i}_split_self_aln.paf > dups.bed
get_seqs -e -p ${i} dups.bed ${i}.p_ctg.fasta ### -e  
mv purged.fa ${i}.purged.fasta

kat comp -o ${i}_pctg -t 52 -H 10000000000 -I 10000000000 -m 31 -h ${i}.ccs.fasta.gz ${i}.p_ctg.fasta
kat comp -o ${i}_purged -t 52 -H 10000000000 -I 10000000000 -m 31 -h ${i}.ccs.fasta.gz ${i}.purged.fasta

source /home/huyong/software/anaconda3/bin/activate /home/huyong/software/anaconda3/envs/busco-5.0

busco -i ${i}.p_ctg.fasta -l /public/agis/huangsanwen_group/lihongbo/database/embryophyta_odb10 -o ${i}_pctg_busco -m geno -c 52 --offline -f --augustus
busco -i ${i}.purged.fasta -l /public/agis/huangsanwen_group/lihongbo/database/embryophyta_odb10 -o ${i}_purged_busco -m geno -c 52 --offline -f --augustus

done

