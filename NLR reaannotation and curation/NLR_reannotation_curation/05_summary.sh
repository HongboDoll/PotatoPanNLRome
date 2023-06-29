#!/bin/bash

ls purged | grep Sol | while read i
do
        for n in purged
        do
        	./summary_NLRtracker.py ${n}/${i}/*_NLRtracker.tsv whole_genome_${n}/${i}/*_NLRtracker.tsv ${i}_NLR_class_summary_NLRtracker.xls ${i}_NLR_class_summary_whole_genome.xls
			cat ${i}_NLR_class_summary_NLRtracker.xls ${i}_NLR_class_summary_whole_genome.xls | awk 'BEGIN{OFS="\t"}{print $1,$1"_NLR_"$3}' > ${i}_corres
        done
done

ls purged | grep Sol | while read i
do
    cat purged/gff3/${i}.purged.filter.NLR.rename.gff3 whole_genome_purged/gff3/${i}.purged.filter.rename.gff3 > tmp
	
	./merge_NLR_tracker_whole_genome.py tmp ${i}_NLR_class_summary_NLRtracker.xls ${i}_NLR_class_summary_whole_genome.xls > ${i}_NLR_class_summary.xls
	
    ./rename_gff3_mRNA_ID.py tmp ${i}_NLR_class_summary.xls ${i}_corres > nlr_gff3/${i}.filter.NLR.rename.gff3
	
    cat purged/pep/${i}.purged.filter.NLR.pep.fa whole_genome_purged/pep/${i}.purged.filter.pep.fa > tmp
    ./output_NLR_pep.py tmp ${i}_NLR_class_summary.xls > nlr_pep/${i}.filter.NLR.pep.fa
	
	cut -f '3' ${i}_NLR_class_summary.xls | sort | uniq -c > ${i}_NLR_class_count.xls
done

