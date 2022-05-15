#!/bin/bash

ref=C400_hifiasm.purged.filter.fa
ref_sm=C400_hifiasm.purged.filter.fa.softmask
threads=52

source activate /home/lianqun/miniconda3/envs/EDTA ## run this in shell

EDTA.pl --genome $ref --step all --overwrite 1 --anno 1 --threads ${threads}
ln -s $PWD/*.EDTA.anno/*mod.masked ${ref}.masked
# 
bedtools maskfasta -soft -fi ${spe}_hifiasm.purged.filter.fa -bed ${spe}_hifiasm.purged.filter.fa.mod.EDTA.TEanno.gff3 -fo $ref_sm
