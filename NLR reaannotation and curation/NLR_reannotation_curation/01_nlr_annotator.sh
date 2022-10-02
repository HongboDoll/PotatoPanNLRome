#!/bin/bash

nlr_path=/vol1/agis/huangsanwen_group/lihongbo/software/NLR-annotator
threads=20


for i in C509 C555 #C672  C850  C871  C400  C534 C509
do
    java -jar $nlr_path/ChopSequence.jar -i ${i}_hifiasm.purged.filter.fa -o ${i}.chop.fa

    java -jar $nlr_path/NLR-Parser.jar -t ${threads} -y /vol1/agis/huangsanwen_group/lihongbo/software/meme_4.9.1/bin/mast -x $nlr_path/meme.xml -i ${i}.chop.fa -c ${i}.nlr.xml -o ${i}.nlr.tab

    java -jar $nlr_path/NLR-Annotator.jar -i ${i}.nlr.xml -o ${i}.nlr.txt  -f $i ${i}.nlr.flanking4k.fa 2000 -m ${i}.nlr.motif.bed -g ${i}.NLR.gff3 -b ${i}.nlr.bed
done

rm -rf NLR_gff/; mkdir NLR_gff/
cp *.NLR.gff3 NLR_gff/

rm -rf NLR_4k_gff NLR_4k_seq/; mkdir NLR_4k_gff NLR_4k_seq/
ls NLR_gff/*gff3 | while read i
do
    name=`echo $i | awk -F '/' '{print $2}' | awk -F '.' '{print $1}'`
    grep -v '#' $i | sort -k1,1 -k4,4n -k5,5n | ./remove_nested_NLR_revise_flanking.py 4000 > NLR_4k_gff/${name}.NLR.4k.gff3
    cat NLR_4k_gff/${name}.NLR.4k.gff3 | while read n
    do
        seq=`echo $n | awk -F '=' '{print $2}'`
        chr=`echo $n | awk '{print $1}'`
        start=`echo $n | awk '{print $4}'`
        end=`echo $n | awk '{print $5}'`
        samtools faidx ${name}_hifiasm.purged*.fa ${chr}:${start}-${end} | awk '{if($1~/>/){print ">""'"$seq"'"}else{print $0}}' >> NLR_4k_seq/${name}.NLR.4k.fa
    done
done


