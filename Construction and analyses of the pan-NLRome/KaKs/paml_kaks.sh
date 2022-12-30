#!/bin/bash

####### codon alignment
#rm -rf single_clade_codon_alignment; mkdir single_clade_codon_alignment
#grep -v 'Cluster' 52_potato_single-copy_clade.tsv | awk '{print $1}' | while read i
#do
#    rm -rf ${i}
#    cat single_clade_cds/${i}/*fa > ${i}_cds.fa
#    cat ${i}_cds.fa|grep '>'|sed 's/>//g'|sed ':a;N;s/\n/ /g;ta' > ${i}_arrangement
#    ParaAT_merely_codon_alignment.pl -h ${i}_arrangement -n all_NLR_cds.fa -a all_NLR_pep.fa -p proc -o ${i} -m muscle -f fasta && mv ${i}/tmpttt.cds_aln.fasta single_clade_codon_alignment/${i}_codon.out
#    rm -rf ${i}
#    ParaAT_merely_codon_alignment.pl -h ${i}_arrangement -n all_NLR_cds.fa -a all_NLR_pep.fa -p proc -o ${i} -m muscle -f axt -kaks && mv ${i}/tmpttt.cds_aln.axt.kaks single_clade_codon_alignment/${i}.kaks
    #rm -rf ${i}
#done

####### Kaks

#source activate /home/jiayuxin/anaconda3/envs/paml

#grep -v 'Cluster' 52_potato_single-copy_clade.tsv | awk '{print $1}' | while read i
#do
#    awk 'BEGIN{n=1}{if($1~/>/){split($1,a,"_NLR_");print a[1]"_"n;n+=1}else{print $0}}' single_clade_codon_alignment/${i}_codon.out > single_clade_codon_alignment/${i}_codon.out2
#    awk 'BEGIN{n=1}{if($1~/>/){split($1,a,"_NLR_");print $1,a[1]"_"n;n+=1}else{print $0}}' single_clade_codon_alignment/${i}_codon.out | grep '>' | sed 's/>//g' > single_clade_codon_alignment/${i}_correspondance
#    fa2phy.py -i single_clade_codon_alignment/${i}_codon.out2 -o single_clade_codon_alignment/${i}_codon.phylip
#
#    cat single_clade_codon_alignment/${i}_correspondance | while read d
#    do
#        n1=`echo $d | awk '{print $1}'`
#        n2=`echo $d | awk '{print $2}'`
#        sed -i "s/${n1}/${n2}/g" clade_tree/${i}.fa.treefile
#    done
#	java -jar $li/bin/PareTree1.0.2.jar -t O -f clade_tree/${i}.fa.treefile -del clade_tree/del -nbs -topo
#	mv clade_tree/${i}_pared.fa.treefile clade_tree/${i}_nbs.fa.treefile
#	rm -rf ${i}_paml; mkdir ${i}_paml
#echo -e """#!/bin/bash
#	cd ${i}_paml
#	cp ../codeml_${i}.ctl .
#	source activate /home/jiayuxin/anaconda3/envs/paml
#	codeml codeml_${i}.ctl
#	cd -
#""" > codeml_${i}.sh && chmod 755 codeml_${i}.sh
#	sbatch -J codeml_${i} -p gpu -N 1 --ntasks-per-node=1 -e %x.err -o %x.out "./codeml_${i}.sh" 
#
#done


#grep -v 'Cluster' 52_potato_nonsingle-copy_clade.tsv | awk '{print $1}' | while read i
#do
#    awk 'BEGIN{n=1}{if($1~/>/){split($1,a,"_NLR_");print a[1]"_"n;n+=1}else{print $0}}' nonsingle_clade_codon_alignment/${i}_codon.out > nonsingle_clade_codon_alignment/${i}_codon.out2
#    awk 'BEGIN{n=1}{if($1~/>/){split($1,a,"_NLR_");print $1,a[1]"_"n;n+=1}else{print $0}}' nonsingle_clade_codon_alignment/${i}_codon.out | grep '>' | sed 's/>//g' > nonsingle_clade_codon_alignment/${i}_correspondance
#    fa2phy.py -i nonsingle_clade_codon_alignment/${i}_codon.out2 -o nonsingle_clade_codon_alignment/${i}_codon.phylip
#
#    cat nonsingle_clade_codon_alignment/${i}_correspondance | while read d
#    do
#        n1=`echo $d | awk '{print $1}'`
#        n2=`echo $d | awk '{print $2}'`
#        sed -i "s/${n1}/${n2}/g" clade_tree/${i}.fa.treefile
#    done
#    java -jar $li/bin/PareTree1.0.2.jar -t O -f clade_tree/${i}.fa.treefile -del clade_tree/del -nbs -topo
#	mv clade_tree/${i}_pared.fa.treefile clade_tree/${i}_nbs.fa.treefile
#    rm -rf ${i}_paml; mkdir ${i}_paml
#echo -e """#!/bin/bash
#    cd ${i}_paml
#    cp ../codeml_${i}.ctl .
#    source activate /home/jiayuxin/anaconda3/envs/paml   
#    codeml codeml_${i}.ctl
#    cd -
#""" > codeml_${i}.sh && chmod 755 codeml_${i}.sh
#    sbatch -J codeml_${i} -p gpu -N 1 --ntasks-per-node=1 -e %x.err -o %x.out "./codeml_${i}.sh"
#
#done

rm nonsingle_clade_kaks_PAML.xls
grep -v 'Cluster' 52_potato_nonsingle-copy_clade.tsv | awk '{print $1}' | while read i
do
	kaks=`grep omega ${i}_paml/${i} | awk '{print $NF}'`
	echo -e "${i}\t$kaks" | awk '{if(NF==1){print $1"\tNA"}else{print $0}}' >> nonsingle_clade_kaks_PAML.xls
done

rm single_clade_kaks_PAML.xls
grep -v 'Cluster' 52_potato_single-copy_clade.tsv | awk '{print $1}' | while read i
do
	kaks=`grep omega ${i}_paml/${i} | awk '{print $NF}'`
	echo -e "${i}\t$kaks" | awk '{if(NF==1){print $1"\tNA"}else{print $0}}' >> single_clade_kaks_PAML.xls
done

