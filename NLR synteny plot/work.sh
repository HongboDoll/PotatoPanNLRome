#!/bin/bash

#cat error_correspondance.xls | while read i
#do
#	name=`echo $i | awk '{print $1}'`
#	move=`echo $i | awk '{print $2}'`
#	sed -i "s/${move}/${name}/g" ${name}.bed
#done


#n=1
#rm 52_potato.caj1.bed
#cat caj1_gene_list.xls | while read i
#do
#	spe=`echo $i | awk '{print $2}'`
#	gene=`echo $i | awk '{print $1}'`
#	n_row=`awk '{if($4=="'"$gene"'"){print NR}}' ${spe}.bed`
#	start=`expr $n_row - 3`
#	end=`expr $n_row + 3`
#	sed -n "${start},${end}p" ${spe}.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/&&$4!="'"$gene"'"){print $4,$1,$2,$3,$6,"'"$n"'","yellow"}else if($4~/_NLR_/&&$4=="'"$gene"'"){print $4,$1,$2,$3,$6,"'"$n"'","red"}else{print $4,$1,$2,$3,$6,"'"$n"'","blue"}}' >> 52_potato.caj1.bed
#	sed -n "${start},${end}p" ${spe}.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/&&$4!="'"$gene"'"){print $4,$1,$2,$3,$6,"'"$n"'","yellow"}else if($4~/_NLR_/&&$4=="'"$gene"'"){print $4,$1,$2,$3,$6,"'"$n"'","red"}else{print $4,$1,$2,$3,$6,"'"$n"'","blue"}}' > ${spe}.caj1.bed
#	n=`expr $n + 1`
#done

rm caj1_aln_region.xls
for i in `seq 1 51`
do
	order1=`echo $i`
	order2=`expr $i + 1`
	spe1=`awk '$NF=="'"$order1"'"' caj1_gene_list.xls | awk '{print $2}'`
	spe2=`awk '$NF=="'"$order2"'"' caj1_gene_list.xls | awk '{print $2}'`
#	awk 'NR!=1' DM_51_potato_genetribe_one2one_matrix.xls | cut -f '2-99' | awk -v n1=$order1 -v n2=$order2 '{print $n1"\t"$n2}' > ${spe1}_${spe2}.one2one
	./output_two_spe_aln_4_plot.py ${spe1}.caj1.bed ${spe2}.caj1.bed ${spe1} ${spe2} ${spe1}_${spe2}.one2one $order2 >> caj1_aln_region.xls

done

