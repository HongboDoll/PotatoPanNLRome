#!/bin/bash

#ls results/Sol* | grep ':'|awk -F '/' '{print $2}'|sed 's/://g' > 52_potato_list.xls

#rm -rf tmp; mkdir tmp
#cat ID_use_for_kaks.xls | while read i
#do
#    cat 52_potato_list.xls | while read n
#    do
#        ./find_ID_NLR_nonNLR_position.py results/${n}/*filter.txt results_whole_genome/${n}/*.parsed.verbose ${i} ${n} tmp/${n}_${i}_NLR tmp/${n}_${i}_nonNLR
#    done
#    paste <(echo $i) tmp/Sol*_${i}_NLR > tmp/52_potato_${i}_NLR
#    paste <(echo $i ) tmp/Sol*_${i}_nonNLR > tmp/52_potato_${i}_nonNLR
#done
#
#cat head <(cat tmp/52_potato_*_NLR) > 52_potato_ID_NLR_4_kaks.xls
#cat head <(cat tmp/52_potato_*_nonNLR) > 52_potato_ID_nonNLR_4_kaks.xls
#

#### NLR-ID and non-NLR-ID genes occupancy >=4, same species set to comput ka/ks
#### output arrgement: 100 randomly selected paired combination for each ID
#rm -rf arrangement; mkdir arrangement
#cat ID_use_for_kaks.xls | while read i
#do
#	./output_4_arrangement.py 52_potato_ID_NLR_4_kaks.xls 52_potato_ID_nonNLR_4_kaks.xls $i arrangement/${i}_NLR_4_arrangement arrangement/${i}_nonNLR_4_arrangement
#	nlr=arrangement/${i}_NLR_4_arrangement
#	nonnlr=arrangement/${i}_nonNLR_4_arrangement
#	./output_arrangement.py $nlr 2 | awk -F '_NLR_' '{split($3,a," ");if($1!=a[2]){print $0}}' | shuf -n 100 > arrangement/${i}_NLR_100_arrangement
#	./output_arrangement.py $nonnlr 2 | awk '{split($1,a,"_");split($2,b,"_");if(a[1]"_"a[2]!=b[1]"_"b[2]){print $0}}' | shuf -n 100 > arrangement/${i}_nonNLR_100_arrangement
#done

#### extract sequences
#rm 52_potato_ID_NLR_4_kaks_pep.fa
#cat arrangement/*_NLR_100_arrangement | sed 's/ /\n/g' | sort | uniq | while read i
#do
#	samtools faidx all_NLR_pep.fa $i >> 52_potato_ID_NLR_4_kaks_pep.fa
#done
#
#rm 52_potato_ID_NLR_4_kaks_cds.fa
#cat arrangement/*_NLR_100_arrangement | sed 's/ /\n/g' | sort | uniq | ./convert_pep_coordinate_2_cds.py | while read i
#do
#	samtools faidx all_NLR_cds.fa $i >> 52_potato_ID_NLR_4_kaks_cds.fa
#done
#
#rm 52_potato_ID_nonNLR_4_kaks_pep.fa
#cat arrangement/*_nonNLR_100_arrangement | sed 's/ /\n/g' | sort | uniq | while read i
#do
#	samtools faidx all_whole_genome_pep.fa $i >> 52_potato_ID_nonNLR_4_kaks_pep.fa
#done
#
#rm 52_potato_ID_nonNLR_4_kaks_cds.fa
#cat arrangement/*_nonNLR_100_arrangement | sed 's/ /\n/g' | sort | uniq | ./convert_pep_coordinate_2_cds.py | while read i
#do
#	samtools faidx all_whole_genome_cds.fa $i >> 52_potato_ID_nonNLR_4_kaks_cds.fa
#done

#### compute ka/ks

#### remove ":" in fasta headers
#for i in NLR nonNLR
#do
#	awk '{if($1~/>/){split($1,a,":");print a[1]}else{print $0}}' 52_potato_ID_${i}_4_kaks_cds.fa > t && mv t 52_potato_ID_${i}_4_kaks_cds.fa
#	awk '{if($1~/>/){split($1,a,":");print a[1]}else{print $0}}' 52_potato_ID_${i}_4_kaks_pep.fa > t && mv t 52_potato_ID_${i}_4_kaks_pep.fa
#	ls -l arrangement/*_NLR_100_arrangement|awk '$5!=0'|grep -v 'total' | awk '{print $NF}'|awk -F '/' '{print $2}' |awk -F '_NLR_' '{print $1}' | while read id
#	do
#		awk '{split($1,a,":");split($2,b,":");print a[1],b[1]}' arrangement/${id}_${i}_100_arrangement > t && mv t arrangement/${id}_${i}_100_arrangement
#	done
#done

#rm -rf kaks_results; mkdir kaks_results
#for i in NLR nonNLR
#do
#	ls -l arrangement/*_NLR_100_arrangement|awk '$5!=0'|grep -v 'total' | awk '{print $NF}'|awk -F '/' '{print $2}' |awk -F '_NLR_' '{print $1}' | while read id
#	do
#	echo -e """#!/bin/bash
#		rm -rf ${i}_${id}_paraAT_results 
#		ParaAT.pl -h arrangement/${id}_${i}_100_arrangement -n 52_potato_ID_${i}_4_kaks_cds.fa -a 52_potato_ID_${i}_4_kaks_pep.fa -p proc -o ${i}_${id}_paraAT_results -m muscle -f axt -k 
#		find ${i}_${id}_paraAT_results/  -name *kaks | xargs -i cat {} | grep -v Sequence|awk '{print \$3,\$4,\$5}'|grep -v NA  > kaks_results/${i}_${id}_kaks.xls
#		sort -k3,3nr kaks_results/${i}_${id}_kaks.xls |grep -v e|awk '\$3<=10' > tmp${id}_${i} && mv tmptmp${id}_${i} kaks_results/${i}_${id}_kaks.xls && rm tmp${id}_${i}
#	""" > ${i}_${id}.sh && chmod 755 ${i}_${id}.sh
#	sbatch -J kaks_${id}_${i} -p gpu -N 1 --ntasks-per-node=1 -e %x.err -o %x.out "./${i}_${id}.sh" 
#	done
#done
#

echo -e "ID\tKaKs_NLR_ID\tKaKs_nonNLR_ID" > ID_KaKs.xls
ls -l arrangement/*_NLR_100_arrangement|awk '$5!=0'|grep -v 'total' | awk '{print $NF}'|awk -F '/' '{print $2}' |awk -F '_NLR_' '{print $1}' | while read i
do
    nlr_kaks=`cat kaks_results/NLR_${i}_kaks.xls | awk '$3<=10' | awk '{i+=$NF}END{print i/NR}'`
    nonnlr_kaks=`cat kaks_results/nonNLR_${i}_kaks.xls | awk '$3<=10' | awk '{i+=$NF}END{print i/NR}'`
    echo -e "${i}\t${nlr_kaks}\t${nonnlr_kaks}" >> ID_KaKs.xls
done


