#!/bin/bash

date
spe=C400
ref=../NLR_2k_seq/${spe}.NLR.2k.fa
ref2=${spe}_hifiasm.purged.filter.fa
threads=52
aug_spe=${spe}_braker

sed "s/augustus_species=/augustus_species=${aug_spe}/g" ../maker_opts.ctl > maker_opts.ctl1

rm -rf ${spe}.maker.output
/public/agis/huangsanwen_group/lihongbo/software/mpich/bin/mpiexec -n $threads /public/agis/huangsanwen_group/lihongbo/software/maker/bin/maker -genome $ref -base ${spe} maker_opts.ctl1 maker_bopts.ctl maker_exe.ctl

/public/agis/huangsanwen_group/lihongbo/software/maker/bin/gff3_merge -d ${spe}.maker.output/*_index.log

awk '$2=="maker"' ${spe}.all.gff > ${spe}.purged.all.NLR.gff3

../convert_NLR_gff_coordinates.py ../NLR_2k_gff/${spe}.NLR.2k.gff3 ${spe}.purged.all.NLR.gff3 > tt && mv tt ${spe}.purged.all.NLR.gff3

/public/agis/huangsanwen_group/lihongbo/software/maker/bin/quality_filter.pl -a 0.5 ${spe}.purged.all.NLR.gff3 > ${spe}.purged.filter.NLR.gff3

#maker_AED_rename_ch.pl -n Soltu_${spe}_NLR_ -gff ${spe}.purged.filter.NLR.gff3 && mv AED_1.maker.gff ${spe}.purged.filter.NLR.rename.gff3

write_fasta_from_gff.pl --fasta $ref2 --gff ${spe}.purged.filter.NLR.gff3 --type=protein --output ${spe}.purged.filter.NLR.pep.fa

