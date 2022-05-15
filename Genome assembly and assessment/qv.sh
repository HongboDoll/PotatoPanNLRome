#!/bin/bash

for i in C400 C509 C534 C555 C672 C871
do
threads=52

fastp -i C_data/${i}_*_1.clean.fq.gz -I C_data/${i}_*_2.clean.fq.gz -o C_data/${i}_1.clean.fastp.fq.gz -O C_data/${i}_2.clean.fastp.fq.gz -w 16

yak count -b37 -t${threads} -o ${i}.yak <(zcat C_data/${i}*.clean.fastp.fq.gz) <(zcat C_data/${i}*.clean.fastp.fq.gz)

yak qv -t${threads} -p -K3.2g -l100k ${i}.yak ${i}_hifiasm.p_ctg.filter.fasta > ${i}_pctg.qv.txt
yak qv -t${threads} -p -K3.2g -l100k ${i}.yak ${i}_hifiasm.purged.filter.fa > ${i}_purged.qv.txt

done

