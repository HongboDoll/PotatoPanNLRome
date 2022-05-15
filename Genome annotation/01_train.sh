#!/bin/bash

ref=
spe=Solanum_sisymbriifolium
threads=52
fastq1=Solanum_sisymbriifolium_merged_clean_R1.fq.gz  ## 1
fastq2=Solanum_sisymbriifolium_merged_clean_R2.fq.gz  ## 2
pasa_spe=test_nlr_${spe} ## should be in coordance with that in pasa.alignAssembly.Template.txt
augustus_species=/public/agis/huangsanwen_group/lihongbo/software/miniconda3/config/species
aug_spe=${spe}_braker

sed "s/DATABASE=/DATABASE=${pasa_spe}/g" pasa.alignAssembly.Template.txt > ${spe}.pasa.alignAssembly.Template.txt1
date


######## EDTA TE masking
source activate /home/lianqun/miniconda3/envs/EDTA

EDTA.pl --genome $ref --step all --overwrite 1 --anno 1 --threads ${threads}
ln -s $PWD/*.EDTA.anno/*mod.masked ${ref}.masked

ref=Solanum_sisymbriifolium.fa
ref_sm=Solanum_sisymbriifolium_softmask.fa

######## Hisat and stringtie and braker
conda deactivate # (aviod perl symbol lookup error)
hisat2-build -p ${threads} $ref $ref

hisat2 -x $ref --dta -1 ${fastq1} -2 ${fastq2} -p ${threads} | samtools sort -@ ${threads} -m 2G - > ${spe}.sort.bam

stringtie -p ${threads} ${spe}.sort.bam -o stringtie_out

sed 's/StringTie/Cufflinks/g' stringtie_out > ${spe}.transcripts.gtf

gffread -E ${spe}.transcripts.gtf -o - | sed "s#transcript#match#g" | sed "s#exon#match_part#g" > ${spe}.transcripts.gff3

bedtools maskfasta -soft -fi $ref -bed *EDTA.TEanno.gff3 -fo $ref_sm

source activate /public/agis/huangsanwen_group/lihongbo/software/miniconda3/envs/braker
export AUGUSTUS_CONFIG_PATH=/public/agis/huangsanwen_group/lihongbo/software/miniconda3/config

braker.pl \
        --species=${aug_spe} \
        --genome=${ref_sm} \
        --bam=${spe}.sort.bam \
        --workingdir=. \
        --gff3 \
        --nocleanup \
        --softmasking \
        --cores $threads

######## Trinity and PASA 

source activate trinity
Trinity --seqType fq --max_memory 100G --left ${fastq1} --right ${fastq2} --output ./${spe}_trinity_out_no_ref --min_kmer_cov 2 --trimmomatic --normalize_reads --CPU ${threads}

Trinity --genome_guided_bam ./${spe}.sort.bam  --max_memory 100G --genome_guided_max_intron 10000 --output ./${spe}_trinity_out_with_ref --CPU ${threads}

cat ./${spe}_trinity_out_with_ref/Trinity-GG.fasta ./${spe}_trinity_out_no_ref/Trinity.fasta > transcripts.fasta && rm -rf ./${spe}_trinity_out_no_ref ./${spe}_trinity_out_with_ref
cat ./${spe}_trinity_out_with_ref/Trinity-GG.fasta ./${spe}_trinity_out_no_ref/Trinity.fasta > transcripts.fasta
cp transcripts.fasta ${spe}.transcripts.fasta

/home/lihongbo/software/PASApipeline.v2.4.1/misc_utilities/accession_extractor.pl < transcripts.fasta > tdn.accs

/home/lihongbo/software/PASApipeline.v2.4.1/bin/seqclean  transcripts.fasta -v /home/lihongbo/software/PASApipeline.v2.4.1/pasa-plugins/seqclean/seqclean/UniVec.fasta
/home/lihongbo/software/PASApipeline.v2.4.1/Launch_PASA_pipeline.pl -c pasa.alignAssembly.Template.txt1 --trans_gtf transcripts.gtf --TDN tdn.accs -C  -R -g $ref -t  transcripts.fasta.clean -T -u  transcripts.fasta --ALIGNERS blat --CPU ${threads}
/home/lihongbo/software/PASApipeline.v2.4.1/scripts/pasa_asmbls_to_training_set.dbi --pasa_transcripts_fasta ${pasa_spe}.assemblies.fasta --pasa_transcripts_gff3 ${pasa_spe}.pasa_assemblies.gff3
/home/lihongbo/software/PASApipeline.v2.4.1/scripts/pasa_asmbls_to_training_set.extract_reference_orfs.pl ${pasa_spe}.assemblies.fasta.transdecoder.genome.gff3 > Solanum_sisymbriifolium.best_candidates.gff3
#
######### Train SNAP
rm -rf snap; mkdir snap
cd snap
ln -s ../Solanum_sisymbriifolium.best_candidates.gff3
grep -v "^$" Solanum_sisymbriifolium.best_candidates.gff3 > best_candidates_format.gff3
python ../eachgff2zff.py best_candidates_format.gff3 > best_candidates_format.zff
awk '{if($1~/^>..../)print}' best_candidates_format.zff | sort | uniq > pos
python ../changezff2oneline.py pos best_candidates_format.zff genome.ann
python ../change_pos_snap.py ../$ref pos genome.dna
fathom genome.ann genome.dna -gene-stats > erro
fathom genome.ann genome.dna -validate > validate.log
grep OK validate.log > genome.zff2keep
../filter_ann.py genome.zff2keep genome.ann > tmp
mv tmp genome.ann
fathom genome.ann genome.dna -categorize 100
fathom uni.ann uni.dna -export 1000 -plus
forge export.ann export.dna
hmm-assembler.pl my-genome . > my-genome.hmm
cp my-genome.hmm ../
cd ../

######### AUGUSTUS and GeneMark are trained from braker
######### Train AUGUSTUS
#########

##gff2gbSmallDNA.pl Solanum_sisymbriifolium.best_candidates.gff3 $ref 1000 genes.raw.gb
##new_species.pl --species=${aug_spe}_for_bad_removingall${aug_spe}
## etraining --species=${aug_spe}_for_bad_removingall${aug_spe} --/genbank/verbosity=2 genes.raw.gb  > train.err
##cat train.err | /usr/bin/perl -pe 's/.*in sequence (\S+):/$1/' > badgenes.lst
##filterGenes.pl  badgenes.lst genes.raw.gb > train.gb
##
##randomSplit.pl train.gb 300
##new_species.pl --species=${aug_spe}all${aug_spe}
## etraining --species=${aug_spe}all${aug_spe} train.gb.train > train.out
##
##tag=$(/usr/bin/perl -ne 'print "$1" if /tag:\s+\d+\s+\((\S+)\)/' train.out)
##/usr/bin/perl -p -i -e "s#/Constant/amberprob.*#/Constant/amberprob                   $tag#" ${augustus_species}/${aug_spe}all${aug_spe}/*_parameters.cfg
##taa=$(/usr/bin/perl -ne 'print "$1" if /taa:\s+\d+\s+\((\S+)\)/' train.out)
##/usr/bin/perl -p -i -e "s#/Constant/ochreprob.*#/Constant/ochreprob                   $taa#" ${augustus_species}/${aug_spe}all${aug_spe}/*_parameters.cfg
##tga=$(/usr/bin/perl -ne 'print "$1" if /tga:\s+\d+\s+\((\S+)\)/' train.out)
##/usr/bin/perl -p -i -e "s#/Constant/opalprob.*#/Constant/opalprob                    $tga#" ${augustus_species}/${aug_spe}all${aug_spe}/*_parameters.cfg
##
## augustus --species=${aug_spe}all${aug_spe} train.gb.test |tee firsttest.out
##randomSplit.pl train.gb.train 800
##optimize_augustus.pl --species=${aug_spe}all${aug_spe} --rounds=5 --cpus=${threads}  train.gb.train.test --onlytrain=train.gb.train.train --metapars=${augustus_species}/${aug_spe}all${aug_spe}/*_metapars.cfg --kfold=${threads} > optimize.out
## etraining --species=${aug_spe}all${aug_spe} train.gb.train
## augustus --species=${aug_spe}all${aug_spe} train.gb.test |tee second.out
#
########### Train Genemark-ET
##
###rm -rf ${spe}_star_index info run output; mkdir -p ${spe}_star_index
##STAR --runThreadN ${threads} --runMode genomeGenerate --genomeDir ${spe}_star_index --genomeFastaFiles $ref
##STAR --runThreadN ${threads} --runMode alignReads --genomeDir ${spe}_star_index --readFilesIn ${fastq1} ${fastq2} --limitBAMsortRAM 20518930416 --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate
##
##/public/agis/huangsanwen_group/lihongbo/software/gmes_linux_64/star_to_gff.pl --star SJ.out.tab --gff SJ.gff --label STAR && rm Aligned.sortedByCoord.out.bam heinz_star_index
##rm -rf output data run info
##/public/agis/huangsanwen_group/lihongbo/software/miniconda3/bin/perl /public/agis/huangsanwen_group/lihongbo/software/gmes_linux_64/gmes_petap.pl --soft_mask 1 --sequence $ref --ET SJ.gff --cores ${threads} && rm -rf data
##cp output/gmhmm.mod .
#
#
