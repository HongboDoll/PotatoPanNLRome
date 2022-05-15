#!/bin/bash

cat species_list.xls | while read i
do
id=`echo $i | awk '{print $1}'`
name=`echo $i | awk '{print $2}'`
mv *${id}.purged.filter.rename.gff3 ${id}.purged.filter.rename.gff3
done


threads=5
for i in C509 C555 C672 C534 C871 C850 C400
do
ref=${i}*hifiasm.purged.filter.fa
gff=../${i}.purged.filter.rename.gff3
pasa_spe=test_nlr_${i}

rm -rf ${i}; mkdir ${i}; cd ${i}
ln -s $PWD/../files/$ref .; ln -s $PWD/../files/${i}.pasa.alignAssembly.Template.txt1 .
ln -s /vol1/agis/huangsanwen_group/lihongbo/work/solanaceae_project/2021_8_23_luyao/pasa/purged/${i}.transcripts.fasta.clean
sed "s/DATABASE=test_pan_genome/DATABASE=test_nlr_${i}/g" ../../pasa.annotationCompare.txt > pasa.annotationCompare.txt

/vol1/agis/huangsanwen_group/lihongbo/software/PASApipeline-2.3.3/scripts/Load_Current_Gene_Annotations.dbi \
        -c ${i}.pasa.alignAssembly.Template.txt1 \
        -g $ref \
        -P $gff


/vol1/agis/huangsanwen_group/lihongbo/software/PASApipeline-2.3.3/Launch_PASA_pipeline.pl \
        -c pasa.annotationCompare.txt -A \
        -g $ref \
        -t ${i}.transcripts.fasta.clean \
		--CPU ${threads}

longestCDS_PrimaryGff.pl test_nlr_${i}.gene_structures_post_PASA_updates.*.gff3 > ../${i}_purged_PASA_updates_longest_transcript.gff3
cd -
done

cat species_list.xls | while read i
do
id=`echo $i | awk '{print $1}'`
name=`echo $i | awk '{print $2}'`
mv ${id}.purged.filter.rename.gff3 ${name}.purged.filter.rename.gff3
mv ${id}_purged_PASA_updates_longest_transcript.gff3 ${name}.purged_PASA_updates_longest_transcript.gff3
done


