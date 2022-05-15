#!/bin/bash

for i in C400  C534  C672  C850  C871
do
        for n in purged p_ctg
        do
        ./summary_NLRtracker.py ${n}/${i}/*_NLRtracker.tsv whole_genome_${n}/${i}/*_NLRtracker.tsv > ${i}_${n}_NLR_class_summary.xls
        ./summary_NLRtracker.py ${n}/${i}/*_NLRtracker.tsv whole_genome_${n}/${i}/*_NLRtracker.tsv | awk '{print $3}' | sort | uniq -c > ${i}_${n}_NLR_class_count.xls
        done
done

ls purged | grep Sol | while read i
do
    cat purged/pep/${i}.purged.filter.NLR.pep.fa whole_genome_purged/pep/${i}.purged.filter.pep.fa > tmp
    ./output_NLR_pep.py tmp ${i}_NLR_class_summary.xls ${i}_corres > nlr_pep/${i}.filter.NLR.pep.fa
    cat purged/gff3/${i}.purged.filter.NLR.rename.gff3 whole_genome_purged/gff3/${i}.purged.filter.rename.gff3 > tmp
    ./rename_gff3_mRNA_ID.py tmp ${i}_corres> nlr_gff3/${i}.filter.NLR.rename.gff3
done
