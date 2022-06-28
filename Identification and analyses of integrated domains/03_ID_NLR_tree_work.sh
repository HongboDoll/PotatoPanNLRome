#!/bin/bash

i=ID


cat ID_NLR_pfamscan.parsed.verbose|grep NB-ARC > ${i}_CNL_CN_TNL_TN_domain.xls

./output_NB-ARC_coordinates.py ${i}_CNL_CN_TNL_TN_domain.xls > ${i}_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls

rm ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa
cat ${i}_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls | while read n
do
    gene=`echo $n | awk '{print $1}'`
    start=`echo $n | awk '{print $2}'`
    end=`echo $n | awk '{print $3}'`
    samtools faidx ID_involved_gene_pep.fa ${gene}:${start}-${end} | awk '{if($1~/>/){split($1,a,":");print a[1]}else{print $0}}' >> ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa
done

cat ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa > ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa

source /home/huyong/software/anaconda3/bin/activate collinerity

mafft --thread 52 --auto ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa > ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa.out

fa2phy.py -i ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa.out -o ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa.phylip

rm ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa.phylip.* RAxML_*
#iqtree -s ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa.phylip -m MFP -b 100 -safe -nt 10

raxmlHPC-PTHREADS-SSE3 -f a -x 5 -p 5 -# 100 -m PROTGAMMAJTT -s ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa.phylip -n ${i}_refplantNLR_CNL_CN_TNL_TN_NB-ARC_domain.fa -T 52


