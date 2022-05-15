#!/bin/bash

source activate LTR_retriever
for i in C400 C509 C534 C555 C672 C850 C871
do 
gt suffixerator -db ${i}_hifiasm.p_ctg.filter.fasta -indexname ${i}_p_ctg -tis -suf -lcp -des -ssp -sds -dna
gt suffixerator -db ${i}_hifiasm.purged.filter.fa -indexname ${i}_purged -tis -suf -lcp -des -ssp -sds -dna

for n in p_ctg purged
do
gt ltrharvest -index ${i}_${n} -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -motif TGCA -motifmis 1 -similar 85 -vic 10 -seed 20 -seqids yes > ${i}_${n}.harvest.scn
/public/agis/huangsanwen_group/lihongbo/software/LTR_FINDER_parallel-1.1/LTR_FINDER_parallel -seq ${i}_hifiasm.${n}.* -threads 52 -harvest_out -size 1000000 -time 300
cat ${i}_${n}.harvest.scn ${i}_hifiasm.${n}*.finder.combine.scn > ${i}_${n}.rawLTR.scn

done

LTR_retriever -genome ${i}_hifiasm.p_ctg.filter.fasta -inharvest ${i}_p_ctg.rawLTR.scn -threads 52
LTR_retriever -genome ${i}_hifiasm.purged.filter.fa -inharvest ${i}_purged.rawLTR.scn -threads 52

LAI -genome ${i}_hifiasm.p_ctg.filter.fasta -intact ${i}_p_ctg.pass.list -t 52 -all ${i}_p_ctg.out
LAI -genome ${i}_hifiasm.purged.filter.fa -intact ${i}_purged.pass.list -t 52 -all ${i}_purged.out

done
