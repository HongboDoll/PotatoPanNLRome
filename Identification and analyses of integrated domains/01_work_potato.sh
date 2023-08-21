#!/bin/bash

source activate pfam_scan
evalue_threshold=0.05

i=known
#rm -rf results_known/; mkdir results_known/ ; mkdir -p results_known/$i
#./run_pfam_scan.sh pep_known/${i} 22 # 10 is CPU thread used

#perl K-parse_Pfam_domains_v3.1.pl -p pep_known/${i}/pfam/*pfamscan-*.out -e 0.001 -v T -o results_known/${i}/${i}_pfamscan.parsed.verbose

rm -rf results; mkdir results
ls pep | while read i
do
rm -rf results/${i}; mkdir -p results/${i}
./run_pfam_scan.sh pep/${i} 22 # 10 is CPU thread used
#
awk '$13<0.05' pep/${i}/pfam/*pfamscan-*.out > pep/${i}/pfam/${i}_pfamscan_filter.out
perl K-parse_Pfam_domains_v3.1.pl -p pep/${i}/pfam/${i}_pfamscan_filter.out -e 0.05 -v T -o results/${i}/${i}_pfamscan.parsed.verbose

sed "s/80/${i}/g" db_descriptions.txt > results/db_descriptions_${i}.txt
perl K-parse_Pfam_domains_NLR-fusions-v2.2.pl -i results/${i} -e 0.05 -o results/${i} -d results/db_descriptions_${i}.txt # the 2nd column in db_descriptions.txt "Species_ID" must contain $spe or the script report nothing
#
./filter_ID_domain.py results/${i}/${i}_pfamscan.parsed.verbose.NLRSD.txt results/${i}/${i}_NLRSD_stat.xls results/${i}/${i}_NLRSD_gene_stat.xls > results/${i}/${i}_pfamscan.parsed.verbose.NLRSD.filter.txt
#
done
#
#
ls pep | while read i
do
    awk '{print "'"$i"'""\t"$1"\t"$2}' results/${i}/${i}_NLRSD_stat.xls > t; mv t results/${i}/${i}_NLRSD_stat.xls
    awk '{print "'"$i"'""\t"$1"\t"$2}' results/${i}/${i}_NLRSD_gene_stat.xls > t; mv t results/${i}/${i}_NLRSD_gene_stat.xls

done
#

cat results/*/*_NLRSD_stat.xls > 52_potato_NLRSD_stat.xls
./stat_all_NLRSD.py 52_potato_NLRSD_stat.xls > 52_potato_NLRSD_stat_matrix.xls
#

cat results/*/*_NLRSD_gene_stat.xls > 52_potato_NLRSD_gene_stat.xls
./stat_all_NLRSD.py 52_potato_NLRSD_gene_stat.xls > 52_potato_NLRSD_gene_stat_matrix.xls

./filter_singleton_NLR_ID.py 52_potato_NLRSD_stat_matrix.xls 52_potato_NLRSD_gene_stat_matrix.xls 52_potato_NLRSD_stat_matrix.filterSingleton.xls 52_potato_NLRSD_gene_stat_matrix.filterSingleton.xls

### ID involved gene

#rm ID_involved_gene.xls
#grep -v 'Domains' 52_potato_NLRSD_gene_stat_matrix.filterSingleton.xls|awk '{print $1}' | while read i
#do
#    cat results/*/*verbose.NLRSD.filter.txt | grep $i | awk '{print $1"\t""'"$i"'"}' >> ID_involved_gene.xls
#done

rm ID_involved_gene_pep.fa
cat ID_involved_gene.xls | while read i
do
    gene=`echo $i | awk '{print $1}'`
    nlr_id=`echo $i | awk -F '\t' '{print $NF}'`
    give_me_one_seq.pl all_NLR_pep.fa $gene | awk '{if($1~/>/){print ">""'"$nlr_id"'"}else{print $0}}' >> ID_involved_gene_pep.fa
done
