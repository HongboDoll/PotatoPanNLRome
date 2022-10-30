#!/bin/bash 

source activate /home/jiayuxin/anaconda3/envs/ortho

orthofinder -f pep -a 52 -t 52 -T iqtree -M msa -os

./convert_orthcladesroup_2_pan_matrix.py Orthcladesroups.tsv > 52_potato_matrix_core_dispensable_genes.cluster

cut -f '1-53' 52_potato_matrix_core_dispensable_genes.cluster > 52_potato_matrix_core_dispensable_genes.cluster_4_pan

./output_core_dispensable_list.py 52_potato_matrix_core_dispensable_genes.cluster_4_pan 52_potato_pangenome_core_list.txt 52_potato_pangenome_shell_list.txt 52_potato_pangenome_cloud_list.txt > 52_potato_pangenome_core_shell_cloud_occupancy.xls

cat 52_potato_pangenome_core_shell_cloud_occupancy.xls|awk '{print $2}'|sort |uniq -c |sort -k2,2n |sed 's/ /\t/g'> 52_potato_pangenome_core_shell_cloud_occupancy_stat.xls

### gene number in each clades
for i in core shell cloud
do
    rm 52_potato_pangenome_${i}_list_gene_number.txt
    cat 52_potato_pangenome_${i}_list.txt | while read clades
    do
        num_gene=`grep $clades 52_potato_matrix_core_dispensable_genes.cluster_4_pan|head -1 | cut -f '2-99'|sed 's/,/\n/g'|sed 's/\t/\n/g'|wc -l`
        echo -e "${clades}\t${num_gene}" >> 52_potato_pangenome_${i}_list_gene_number.txt
    done
	awk '{i+=$2}END{print i}' 52_potato_pangenome_${i}_list_gene_number.txt
done

### NLR types of cladess

./output_clades_type.py 52_potato_matrix_core_dispensable_genes.cluster > 52_potato_matrix_core_dispensable_genes.cluster.cladestype

awk '{print $NF}' 52_potato_matrix_core_dispensable_genes.cluster.cladestype | sort |uniq -c

echo -e "clades\tCNL\tTNL\tNL\tRNL" > 52_potato_pangenome_core_shell_cloud_cladesType_stat.xls
for i in core shell cloud
do
    rm 52_potato_pangenome_${i}_list_cladesType.txt 
    cat 52_potato_pangenome_${i}_list.txt | while read clades
    do
        grep $clades 52_potato_matrix_core_dispensable_genes.cluster.cladestype | awk '{print "'"$clades"'""\t"$NF}' >> 52_potato_pangenome_${i}_list_cladesType.txt
    done
    echo -e "${i}\t\c" >> 52_potato_pangenome_core_shell_cloud_cladesType_stat.xls
    for n in CNL TNL NL RNL
    do
        count=`awk '"'"$n"'"==$NF' 52_potato_pangenome_${i}_list_cladesType.txt | wc -l`
        echo -e "${count}\t\c" >> 52_potato_pangenome_core_shell_cloud_cladesType_stat.xls
    done
    echo -e "" >> 52_potato_pangenome_core_shell_cloud_cladesType_stat.xls
done

echo -e "clades\tCNL\tTNL\tNL\tRNL" > 52_potato_pangenome_core_shell_cloud_cladesType_gene_number_stat.xls
for i in core shell cloud
do
    rm 52_potato_pangenome_${i}_list_gene_number_cladesType.txt 
    cat 52_potato_pangenome_${i}_list_gene_number.txt | while read clades
    do
        clades_name=`echo $clades | awk '{print $1}'`
        clades_gene_num=`echo $clades | awk '{print $2}'`
        grep $clades_name 52_potato_matrix_core_dispensable_genes.cluster.cladestype | awk '{print "'"${clades_name}"'""\t""'"${clades_gene_num}"'""\t"$NF}' >> 52_potato_pangenome_${i}_list_gene_number_cladesType.txt
    done
    echo -e "${i}\t\c" >> 52_potato_pangenome_core_shell_cloud_cladesType_gene_number_stat.xls
    for n in CNL TNL NL RNL
    do
        count=`awk '"'"$n"'"==$NF' 52_potato_pangenome_${i}_list_gene_number_cladesType.txt | awk '{i+=$2}END{print i}'`
        echo -e "${count}\t\c" >> 52_potato_pangenome_core_shell_cloud_cladesType_gene_number_stat.xls
    done
    echo -e "" >> 52_potato_pangenome_core_shell_cloud_cladesType_gene_number_stat.xls
done

#cat pep/*fa > all_52_potato.faa


#### nearly single copy
./output_nearly_single_copy_clades.py pep/OrthoFinder/Results*/Orthcladesroups/Orthcladesroups.GeneCount.tsv 49 > Orthcladesroups_nearly_single_copy.tsv

