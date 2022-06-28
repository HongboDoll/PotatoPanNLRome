#!/bin/bash

#source /home/huyong/software/anaconda3/bin/activate collinerity

#rm -rf fasta; mkdir fasta
#rm -rf vcf; mkdir vcf
#ls -l arrangement/*_NLR_100_arrangement|awk '$5!=0'|grep -v 'total' | awk '{print $NF}'|awk -F '/' '{print $2}' |awk -F '_NLR_' '{print $1}' | while read i
#do
#    mkdir -p fasta/${i}_NLR; mkdir -p fasta/${i}_nonNLR
#    cat arrangement/${i}_NLR_100_arrangement | sed 's/ /\n/g' | sort | uniq | while read g
#    do
#        samtools faidx all_NLR_cds.fa $g > fasta/${i}_NLR/${g}.cds.fa
#    done
#    
#    cat arrangement/${i}_nonNLR_100_arrangement | sed 's/ /\n/g' | sort | uniq | while read g
#    do
#        samtools faidx all_whole_genome_cds.fa $g > fasta/${i}_nonNLR/${g}.cds.fa
#    done
#    
#    ref=`ls fasta/${i}_NLR/*.cds.fa | awk 'NR==1'`
#    echo -e "chr01\t1\t15000\t$ref\t0\t+" > ref.bed
#    n=1
#    ls fasta/${i}_NLR/*.cds.fa | awk 'NR!=1' | while read query
#    do
#        cat $ref $query > tmp.fa
#        mafft --thread 1 --auto tmp.fa > fasta/${i}_NLR/${i}_${n}.out
#		./output_one_line_fasta.py fasta/${i}_NLR/${i}_${n}.out > t && mv t fasta/${i}_NLR/${i}_${n}.out
#        ./MSA2vcf.py fasta/${i}_NLR/${i}_${n}.out ref.bed $ref $query fasta/${i}_NLR/${i}_${n}.out.vcf
#		bgzip -f fasta/${i}_NLR/${i}_${n}.out.vcf
#		tabix -f -p vcf fasta/${i}_NLR/${i}_${n}.out.vcf.gz
#        n=`expr $n + 1`
#    done
#    vcf=`ls fasta/${i}_NLR/${i}*.out.vcf.gz`
#    bcftools merge -m all --threads 52 $vcf | bcftools view -v snps > vcf/${i}_NLR_cds.vcf
#	bcftools norm -m -any vcf/${i}_NLR_cds.vcf | awk '{if($1~/#/){print $0}else{if(length($3)==1&&length($4)==1){print $0}}}' >  vcf/${i}_NLR_cds_biallelic.vcf
#	vcftools --vcf  vcf/${i}_NLR_cds_biallelic.vcf --TajimaD 1 --out vcf/${i}_NLR_cds_biallelic.vcf
    
#    ref=`ls fasta/${i}_nonNLR/*.cds.fa | awk 'NR==1'`
#    echo -e "chr01\t1\t15000\t$ref\t0\t+" > ref.bed
#    n=1
#    ls fasta/${i}_nonNLR/*.cds.fa | awk 'NR!=1' | while read query
#    do
#        cat $ref $query > tmp.fa
#        mafft --thread 1 --auto tmp.fa > fasta/${i}_nonNLR/${i}_${n}.out
#		./output_one_line_fasta.py fasta/${i}_nonNLR/${i}_${n}.out > t && mv t fasta/${i}_nonNLR/${i}_${n}.out
#        ./MSA2vcf.py fasta/${i}_nonNLR/${i}_${n}.out ref.bed $ref $query fasta/${i}_nonNLR/${i}_${n}.out.vcf
#		bgzip -f fasta/${i}_nonNLR/${i}_${n}.out.vcf
#		tabix -f -p vcf fasta/${i}_nonNLR/${i}_${n}.out.vcf.gz
#        n=`expr $n + 1`
#    done
#    vcf=`ls fasta/${i}_nonNLR/${i}*.out.vcf.gz`
#    bcftools merge -m all --threads 52 $vcf | bcftools view -v snps > vcf/${i}_nonNLR_cds.vcf
#    bcftools norm -m -any vcf/${i}_nonNLR_cds.vcf | awk '{if($1~/#/){print $0}else{if(length($5)==1&&length($4)==1){print $0}}}' >  vcf/${i}_nonNLR_cds_biallelic.vcf
#	vcftools --vcf  vcf/${i}_nonNLR_cds_biallelic.vcf --TajimaD 1 --out vcf/${i}_nonNLR_cds_biallelic.vcf    
#done

echo -e "ID\tTajimasD_NLR_ID\tTajimasD_nonNLR_ID" > ID_TajimasD.xls
ls -l arrangement/*_NLR_100_arrangement|awk '$5!=0'|grep -v 'total' | awk '{print $NF}'|awk -F '/' '{print $2}' |awk -F '_NLR_' '{print $1}' | while read i
do
    nlr_tajimasd=`grep -v 'TajimaD' vcf/${i}_NLR_cds_biallelic.vcf.Tajima.D | awk '{i+=$NF}END{print i/NR}'`
    nonnlr_tajimasd=`grep -v 'TajimaD' vcf/${i}_nonNLR_cds_biallelic.vcf.Tajima.D | awk '{i+=$NF}END{print i/NR}'`
    echo -e "${i}\t${nlr_tajimasd}\t${nonnlr_tajimasd}" >> ID_TajimasD.xls
done


