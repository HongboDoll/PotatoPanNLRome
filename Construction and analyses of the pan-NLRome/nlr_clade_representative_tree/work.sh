#!/bin/bash

##### extract pep seq from each NLR clade
#for i in `seq 2 490`
#do
#    clade=`awk 'NR=="'"$i"'"' 52_potato_matrix_core_dispensable_genes.cluster | awk '{print $1}'`
#    awk 'NR=="'"$i"'"' 52_potato_matrix_core_dispensable_genes.cluster | cut -f '2-53' | sed 's/,/\n/g' | sed 's/\t/\n/g' | awk '$1!="-"' > ${clade}_gene_list.xls
#done
#
#rm -rf panNLR_clade_NLR_pep_seq; mkdir panNLR_clade_NLR_pep_seq
#rm ext.sh
#ls Clade*_gene_list.xls | while read i
#do
#    cat $i | while read n
#    do
#    echo -e "give_me_one_seq.pl all_52_potato.faa $n >> panNLR_clade_NLR_pep_seq/${i}.fa" >> ext.sh
#    done
#done
#
#split -a 2 -d -l 13000 ext.sh  ext.sh_ && chmod 755 ext.sh*

#for i in {00..02}
#do
#    echo -e "#!/bin/bash\ncat ./ext.sh_${i} | parallel -j 52" > ext_run${i}.sh && chmod 755 ext_run${i}.sh
#    sbatch -J ext${i} -p queue1 --qos=queue1 -N 1 --ntasks-per-node=52 -e %x.err -o %x.out "./ext_run${i}.sh"
#done


##### extract representative NLR NB domain sequences
#rm 489_NLR_clades_representative_NLR_gene.xls
#awk 'NR!=1' 52_potato_matrix_core_dispensable_genes.cluster | awk '{print $1}' | while read i
#do
#	gene=`out_len.py panNLR_clade_NLR_pep_seq/${i}_gene_list.xls.fa | grep -v TX | grep -v CCX | grep -v OTHER | sort -k2,2nr | head -1 | awk '{print $1}' | sed 's/>//g'`
#	echo -e "${i}\t${gene}" >> 489_NLR_clades_representative_NLR_gene.xls
#done
#awk 'NF==2' 489_NLR_clades_representative_NLR_gene.xls > t && mv t 489_NLR_clades_representative_NLR_gene.xls
#
#cat /public/agis/huangsanwen_group/lihongbo/work/solanaceae_project/2021_8_23_luyao/nlr_ID/results/Solanum_*/*_pfamscan.parsed.verbose > 52_potato_pfamscan.parsed.verbose
#grep NB-ARC 52_potato_pfamscan.parsed.verbose > 52_potato_pfamscan.parsed.verbose.NB-ARC.xls
#./output_NB-ARC_coordinates.py 52_potato_pfamscan.parsed.verbose.NB-ARC.xls > 52_potato_pfamscan.parsed.verbose.NB-ARC.coordinates.xls
#
#rm 489_NLR_clades_representative_NLR_gene_NB-ARC.coordinates.xls
#cat 489_NLR_clades_representative_NLR_gene.xls | while read l
#do
#	i=`echo $l | awk '{print $2}'`
#	clade=`echo $l | awk '{print $1}'`
#	paste <(echo $clade) <(grep $i 52_potato_pfamscan.parsed.verbose.NB-ARC.coordinates.xls) >> 489_NLR_clades_representative_NLR_gene_NB-ARC.coordinates.xls
#done

rm 489_NLR_clades_representative_NLR_gene_NB-ARC.fa
cat 489_NLR_clades_representative_NLR_gene_NB-ARC.coordinates.xls | while read n
do
	clade=`echo $n | awk '{print $1}'`
    gene=`echo $n | awk '{print $2}'`
    start=`echo $n | awk '{print $3}'`
    end=`echo $n | awk '{print $4}'`
    samtools faidx all_52_potato.faa ${gene}:${start}-${end} | awk '{if($1~/>/){print ">""'"$clade"'"}else{print $0}}' >> 489_NLR_clades_representative_NLR_gene_NB-ARC.fa
done

##### phylogenetic tree
source /home/huyong/software/anaconda3/bin/activate collinerity

mafft --thread 52 --auto 489_NLR_clades_representative_NLR_gene_NB-ARC.fa > 489_NLR_clades_representative_NLR_gene_NB-ARC.fa.out

fa2phy.py -i 489_NLR_clades_representative_NLR_gene_NB-ARC.fa.out -o 489_NLR_clades_representative_NLR_gene_NB-ARC.fa.phylip

rm 489_NLR_clades_representative_NLR_gene_NB-ARC.fa.phylip.* RAxML_*
raxmlHPC-PTHREADS-SSE3 -f a -x 5 -p 5 -# 100 -m PROTGAMMAJTT -s 489_NLR_clades_representative_NLR_gene_NB-ARC.fa.phylip -n 489_NLR_clades_representative_NLR_gene_NB-ARC.fa -T 52

