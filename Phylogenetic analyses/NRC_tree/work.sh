#!/bin/bash

#for i in Solanum_cajamarquenseC534 Solanum_candolleanumC400 Solanum_cardiophyllumC509 Solanum_chacoenseC555 Solanum_commersoniiC672 Solanum_dolichocremastrumC850 Solanum_hintoniiC871
#do
#cat ${i}_pfamscan.parsed.verbose|grep NB-ARC > ${i}_CNL_CN_TNL_TN_domain.xls
#
#./output_NB-ARC_coordinates.py ${i}_CNL_CN_TNL_TN_domain.xls > ${i}_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls
#
#rm ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa
#cat ${i}_CNL_CN_TNL_TN_NB-ARC_domain_coordinates.xls | while read n
#do
#    gene=`echo $n | awk '{print $1}'`
#    start=`echo $n | awk '{print $2}'`
#    end=`echo $n | awk '{print $3}'`
#    samtools faidx nlr_pep/${i}.filter.NLR.pep.fa ${gene}:${start}-${end} | awk '{if($1~/>/){split($1,a,":");split(a[1],b,"_");print a[1]}else{print $0}}' >> ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa
#done
#done

rm -rf NRC_seq; mkdir NRC_seq
for i in Solanum_cajamarquenseC534 Solanum_candolleanumC400 Solanum_cardiophyllumC509 Solanum_chacoenseC555 Solanum_commersoniiC672 Solanum_dolichocremastrumC850 Solanum_hintoniiC871
do
    ls NRCanalysis | grep -v Sola | awk -F '.' '{print $1}'| while read g
    do
        grep ${i} NRCanalysis/${g}.txt > NRCanalysis/${g}.${i}.txt
        cat NRCanalysis/${g}.${i}.txt | while read j
        do
            give_me_one_seq.pl ${i}_CNL_CN_TNL_TN_NB-ARC_domain.fa $j | awk '{if($1~/>/){print $1"~""'"$g"'"}else{print $0}}'>> NRC_seq/${i}.${g}.fa
        done
    done
done

for i in Solanum_cajamarquenseC534 Solanum_candolleanumC400 Solanum_cardiophyllumC509 Solanum_chacoenseC555 Solanum_commersoniiC672 Solanum_dolichocremastrumC850 Solanum_hintoniiC871
do
echo -e """#!/bin/bash
source /home/huyong/software/anaconda3/bin/activate collinerity

cat NRC_seq/${i}*fa > ${i}_NRC_NRC_dep_sensor_NB.fa
mafft --thread 10 --auto ${i}_NRC_NRC_dep_sensor_NB.fa > ${i}_NRC_NRC_dep_sensor_NB.fa.out

fa2phy.py -i ${i}_NRC_NRC_dep_sensor_NB.fa.out -o ${i}_NRC_NRC_dep_sensor_NB.fa.phylip

rm ${i}_NRC_NRC_dep_sensor_NB.fa.phylip.* RAxML_*
#iqtree -s ${i}_NRC_NRC_dep_sensor_NB.fa.phylip -m MFP -b 100 -safe -nt 10
raxmlHPC-PTHREADS-SSE3 -f a -x 5 -p 5 -# 100 -m PROTGAMMAJTT -s ${i}_NRC_NRC_dep_sensor_NB.fa.phylip -n ${i}_NRC_NRC_dep_sensor_NB.fa -T 10
mv RAxML_bestTree.${i}_NRC_NRC_dep_sensor_NB.fa RAxML_bestTree.${i}_NRC_NRC_dep_sensor_NB.fa.tre
""" > ${i}_run.sh && chmod 755 ${i}_run.sh
sbatch -J ${i}_NRC_tree -p gpu -N 1 --ntasks-per-node=10 -e %x.err -o %x.out "./${i}_run.sh" 

done

