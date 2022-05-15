#!/bin/bash

date
spe=C400
ref=${spe}_hifiasm.purged.filter.fa.masked
threads=52
aug_spe=${spe}_braker

sed "s/augustus_species=/augustus_species=${aug_spe}/g" ../maker_opts.ctl > maker_opts.ctl1

source activate /home/chenglin/softwares/miniconda3/envs/maker
export AUGUSTUS_CONFIG_PATH=/public/agis/huangsanwen_group/lihongbo/software/miniconda3/config

rm -rf ${spe}.maker.output
/public/agis/huangsanwen_group/lihongbo/software/mpich/bin/mpiexec -n $threads /public/agis/huangsanwen_group/lihongbo/software/maker/bin/maker -genome $ref -base ${spe} maker_opts.ctl1 maker_bopts.ctl maker_exe.ctl

/public/agis/huangsanwen_group/lihongbo/software/maker/bin/gff3_merge -d ${spe}.maker.output/*_index.log

awk '$2=="maker"' ${spe}.all.gff > ${spe}.purged.all.gff3
/public/agis/huangsanwen_group/lihongbo/software/maker/bin/quality_filter.pl -a 0.5 ${spe}.purged.all.gff3 > ${spe}.purged.filter.gff3

write_fasta_from_gff.pl --fasta $ref --gff ${spe}.purged.filter.gff3 --type=protein --output ${spe}.purged.filter.pep.fa

source /home/huyong/software/anaconda3/bin/activate /home/huyong/software/anaconda3/envs/busco-5.0

busco -i ${spe}.purged.filter.pep.fa -l /public/agis/huangsanwen_group/lihongbo/database/embryophyta_odb10 -o ${spe}_hifiasm.purged_gene_busco -m proteins -c $threads --offline -f --augustus


########## handle FAILED contigs

spe=C400
threads=52
aug_spe=${spe}_braker

cd ${spe}.maker.output
out_len.py ../${spe}_hifiasm.purged.filter.fa | sed 's/>//g' > len

rm problem_ctg_len
cat *index*log | grep FAI | awk '{print $1}' | sort | uniq | while read i
do
    awk '$1=="'"$i"'"' len >> problem_ctg_len
done
sort -k2,2n problem_ctg_len -o ../problem_ctg_len
cd -

sed "s/augustus_species=/augustus_species=${aug_spe}/g" ../maker_opts.ctlerr | sed "s/rmlib=/rmlib=${spe}_hifiasm.purged.filter.fa.mod.EDTA.TElib.fa/g" > maker_opts.ctl1

rm error.fa
awk '{print $1}' problem_ctg_len | sort > 1
sort ../${spe}_id2 > 2
comm -23 1 2 | while read i
do
    give_me_one_seq.pl ${spe}_hifiasm.purged.filter.fa $i >> error.fa
done

ref=error.fa
rm -rf error.maker.output
source activate /home/chenglin/softwares/miniconda3/envs/maker
export AUGUSTUS_CONFIG_PATH=/public/agis/huangsanwen_group/lihongbo/software/miniconda3/config

/public/agis/huangsanwen_group/lihongbo/software/mpich/bin/mpiexec -n $threads /public/agis/huangsanwen_group/lihongbo/software/maker/bin/maker -genome $ref -base error maker_opts.ctl1 maker_bopts.ctl maker_exe.ctl

/public/agis/huangsanwen_group/lihongbo/software/maker/bin/gff3_merge -d error.maker.output/*_index.log

awk '$2=="maker"' error.all.gff > error.purged.all.gff3
/public/agis/huangsanwen_group/lihongbo/software/maker/bin/quality_filter.pl -a 0.5 error.purged.all.gff3 > error.purged.filter.gff3

cp ${spe}.purged.filter.gff3 ${spe}.purged.filter.gff3bak
cat ${spe}.purged.filter.gff3bak error.purged.filter.gff3 > ${spe}.purged.filter.gff3

ref=${spe}_hifiasm.purged.filter.fa

awk '$3=="gene"' ${spe}.purged.filter.gff3 | awk '{print $NF}'|awk -F ';' '{print $1}'|awk -F '=' '{print $2}'|sort | uniq > gene
awk '$3=="mRNA"' ${spe}.purged.filter.gff3 | awk '{print $NF}'|awk -F ';' '{print $1}'|awk -F '=' '{print $2}'|sed 's/-RA//g'|sort | uniq > mRNA
comm -23 mRNA gene | while read i
do
n_row=`cat -n *.filter.gff3|awk '$4=="mRNA"' | grep "${i}-RA" | awk '{print $1}'`
line=`cat *.filter.gff3|awk '$3=="mRNA"' | grep "${i}-RA" | awk -v a=$i 'BEGIN{OFS="\t"}{print $1,$2,"gene",$4,$5,$6,$7,$8,"ID="a";""Name="a}'`
sed "${n_row}i ${line}" -i *.filter.gff3
done
write_fasta_from_gff.pl --fasta $ref --gff ${spe}.purged.filter.gff3 --type=protein --output ${spe}.purged.filter.pep.fa
source /home/huyong/software/anaconda3/bin/activate /home/huyong/software/anaconda3/envs/busco-5.0

busco -i ${spe}.purged.filter.pep.fa -l /public/agis/huangsanwen_group/lihongbo/database/embryophyta_odb10 -o ${spe}_hifiasm.purged_gene_busco -m proteins -c $threads --offline -f --augustus

source activate /home/huyong/software/anaconda3/envs/R_Python

ls *gff3 | while read i
do
    name=`echo $i | awk -F '.' '{print $1}'`
    python -m jcvi.annotation.stats stats $i &> jcvi_stats  && mv jcvi_stats ${name}.stat1
    python -m jcvi.annotation.stats genestats ${i} &> jcvi_genestats && mv jcvi_genestats ${name}.stat2
    python -m jcvi.annotation.stats statstable ${i} &> jcvi_statstable && mv jcvi_statstable ${name}.stat3
    cat  ${name}.stat1 ${name}.stat2 ${name}.stat3 > ${name}.stat
done
