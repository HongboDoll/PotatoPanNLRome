#!/bin/bash

i=C400

cat Solanum_*${i}_pfamscan.parsed.verbose|grep NB-ARC|grep -v 'NLR_NBS'|grep -v 'NLR_TX' |grep -v 'NLR_CCX' | grep -v 'NLR_NL' > ${i}_CNL_CN_TNL_TN_domain.xls
#
./output_NB-ARC_coordinates.py ${i}_CNL_CN_TNL_TN_domain.xls > ${i}_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls

rm ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa
cat ${i}_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls | while read n
do
    gene=`echo $n | awk '{print $1}'`
    start=`echo $n | awk '{print $2}'`
    end=`echo $n | awk '{print $3}'`
    samtools faidx Solanum_*${i}.filter.NLR.pep.fa ${gene}:${start}-${end} | awk '{if($1~/>/){split($1,a,":");split(a[1],b,"_");print ">"b[3]"_"b[4]"_"b[5]"_"b[6]}else{print $0}}' >> ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa
done

cat known_pfamscan.parsed.verbose|grep NB-ARC|grep -v 'NLR_NBS'|grep -v 'NLR_TX' |grep -v 'NLR_CCX' | grep -v 'NLR_NL' > known_CNL_CN_TNL_TN_domain.xls
#
./output_NB-ARC_coordinates.py known_CNL_CN_TNL_TN_domain.xls > known_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls
#
rm known_CNL_CN_TNL_TN_NB-ARC_domain.fa
cat known_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls | while read n
do
    gene=`echo $n | awk '{print $1}'`
    start=`echo $n | awk '{print $2}'`
    end=`echo $n | awk '{print $3}'`
    samtools faidx known.pep.fa ${gene}:${start}-${end} | awk '{if($1~/>/){split($1,a,":");print a[1]}else{print $0}}' >> known_CNL_CN_TNL_TN_NB-ARC_domain.fa
done
#
cat ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa known_CNL_CN_TNL_TN_NB-ARC_domain.fa > ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa
#
source /home/huyong/software/anaconda3/bin/activate collinerity
#
mafft --thread 10 --auto ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa > ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa.out
#
fa2phy.py -i ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa.out -o ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa.phylip
#
rm ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa.phylip.*
raxmlHPC-PTHREADS-SSE3 -f a -x 5 -p 5 -# 100 -m PROTGAMMAJTT -s ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa.phylip -n ${i}_known_CNL_CN_TNL_TN_NB-ARC_domain.fa -T 10


