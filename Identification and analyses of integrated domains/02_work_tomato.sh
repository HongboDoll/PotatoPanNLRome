#!/bin/bash

source activate pfam_scan

i=known
#rm -rf results_known/; mkdir results_known/ ; mkdir -p results_known/$i
#./run_pfam_scan.sh pep_known/${i} 22 # 10 is CPU thread used

#perl K-parse_Pfam_domains_v3.1.pl -p pep_known/${i}/pfam/*pfamscan-*.out -e 0.001 -v T -o results_known/${i}/${i}_pfamscan.parsed.verbose

rm -rf results_tomato; mkdir results_tomato
ls pep_tomato | while read i
do
rm -rf results_tomato/${i}; mkdir -p results_tomato/${i}
./run_pfam_scan.sh pep_tomato/${i} 22 # 10 is CPU thread used
#
awk '$13<0.05' pep_tomato/${i}/pfam/*pfamscan-*.out > pep_tomato/${i}/pfam/${i}_pfamscan_filter.out
perl K-parse_Pfam_domains_v3.1.pl -p pep_tomato/${i}/pfam/${i}_pfamscan_filter.out -e 0.05 -v T -o results_tomato/${i}/${i}_pfamscan.parsed.verbose
#
sed "s/80/${i}/g" db_descriptions.txt > results_tomato/db_descriptions_${i}.txt
perl K-parse_Pfam_domains_NLR-fusions-v2.2.pl -i results_tomato/${i} -e 0.05 -o results_tomato/${i} -d results_tomato/db_descriptions_${i}.txt # the 2nd column in db_descriptions.txt "Species_ID" must contain $spe or the script report nothing
#
./filter_ID_domain.py results_tomato/${i}/${i}_pfamscan.parsed.verbose.NLRSD.txt results_tomato/${i}/${i}_NLRSD_stat.xls results_tomato/${i}/${i}_NLRSD_gene_stat.xls > results_tomato/${i}/${i}_pfamscan.parsed.verbose.NLRSD.filter.txt
#
done
#
#
ls pep_tomato | while read i
do
    awk '{print "'"$i"'""\t"$1"\t"$2}' results_tomato/${i}/${i}_NLRSD_stat.xls > t; mv t results_tomato/${i}/${i}_NLRSD_stat.xls
    awk '{print "'"$i"'""\t"$1"\t"$2}' results_tomato/${i}/${i}_NLRSD_gene_stat.xls > t; mv t results_tomato/${i}/${i}_NLRSD_gene_stat.xls

done
#

cat results_tomato/*/*_NLRSD_stat.xls > 9_tomato_NLRSD_stat.xls
./stat_all_NLRSD.py 9_tomato_NLRSD_stat.xls > 9_tomato_NLRSD_stat_matrix.xls
#

cat results_tomato/*/*_NLRSD_gene_stat.xls > 9_tomato_NLRSD_gene_stat.xls
./stat_all_NLRSD.py 9_tomato_NLRSD_gene_stat.xls > 9_tomato_NLRSD_gene_stat_matrix.xls

./filter_singleton_NLR_ID.py 9_tomato_NLRSD_stat_matrix.xls 9_tomato_NLRSD_gene_stat_matrix.xls 9_tomato_NLRSD_stat_matrix.filterSingleton.xls 9_tomato_NLRSD_gene_stat_matrix.filterSingleton.xls

