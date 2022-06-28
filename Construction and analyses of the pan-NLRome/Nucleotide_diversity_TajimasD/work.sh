#!/bin/bash

#rm 52_potato_nonsingle-copy_OG.tsv
#cat nonsingle_copyOG | while read i
#do
#    grep $i 52_potato_matrix_core_dispensable_genes.cluster >> 52_potato_nonsingle-copy_OG.tsv
#done
#
#./output_OG_occupancy_4.py 52_potato_nonsingle-copy_OG.tsv > t && mv t 52_potato_nonsingle-copy_OG.tsv

#rm -rf single_og_cds; mkdir single_og_cds
#grep -v 'Cluster' 52_potato_single-copy_OG.tsv | while read i
#do
#    og=`echo $i | awk '{print $1}'`
#    mkdir -p single_og_cds/${og}
#	rm ${og}_ext.sh
#    echo $i | cut -d ' ' -f '2-53' | sed 's/ /\n/g' | sed 's/,/\n/g' | awk '$1!="-"' | while read g
#    do
#    echo -e """#!/bin/bash
#        samtools faidx all_NLR_cds.fa $g >> single_og_cds/${og}/${g}.fa
#    """ >> ${og}_ext.sh
#    done
#	chmod 755 ${og}_ext.sh
#    sbatch -J ${og}_ext -p queue1 --qos=queue1 -N 1 --ntasks-per-node=1 -e %x.err -o %x.out "./${og}_ext.sh" 
#done
#
#rm -rf nonsingle_og_cds; mkdir nonsingle_og_cds
#grep -v 'Cluster' 52_potato_nonsingle-copy_OG.tsv | while read i
#do
#    og=`echo $i | awk '{print $1}'`
#	rm ${og}_ext.sh
#    mkdir -p nonsingle_og_cds/${og}
#    echo $i | cut -d ' ' -f '2-53' | sed 's/ /\n/g' | sed 's/,/\n/g' | awk '$1!="-"' | while read g
#    do
#    echo -e """#!/bin/bash
#        samtools faidx all_NLR_cds.fa $g >> nonsingle_og_cds/${og}/${g}.fa
#    """ >> ${og}_ext.sh
#    done
#   chmod 755 ${og}_ext.sh
#    sbatch -J ${og}_ext -p queue1 --qos=queue1 -N 1 --ntasks-per-node=1 -e %x.err -o %x.out "./${og}_ext.sh"
#done


#### single-copy OG
#source /home/huyong/software/anaconda3/bin/activate collinerity
#
#rm -rf single_vcf; mkdir single_vcf
#grep -v 'Cluster' 52_potato_single-copy_OG.tsv | awk '{print $1}' | while read i
#do
#    ref=`ls single_og_cds/${i}/*.fa | awk 'NR==1'`
#    echo -e "chr01\t1\t15000\t$ref\t0\t+" > ref.bed
#    n=1
#    ls single_og_cds/${i}/*.fa | awk 'NR!=1' | while read query
#    do
##        cat $ref $query > tmp.fa
##        mafft --thread 1 --auto tmp.fa > single_og_cds/${i}/${i}_${n}.out
##        ./output_one_line_fasta.py single_og_cds/${i}/${i}_${n}.out > single_og_cds/${i}/t && mv single_og_cds/${i}/t single_og_cds/${i}/${i}_${n}.out
#        ./MSA2vcf.py single_og_cds/${i}/${i}_${n}.out ref.bed $ref $query single_og_cds/${i}/${i}_${n}.out.vcf
#        bgzip -f single_og_cds/${i}/${i}_${n}.out.vcf
#        tabix -f -p vcf single_og_cds/${i}/${i}_${n}.out.vcf.gz
#        n=`expr $n + 1`
#    done
#    vcf=`ls single_og_cds/${i}/${i}*.out.vcf.gz`
#    bcftools merge -m all --threads 1 $vcf | bcftools view -v snps > single_vcf/${i}_NLR_cds.vcf
#    bcftools norm -m -any single_vcf/${i}_NLR_cds.vcf | awk '{if($1~/#/){print $0}else{if(length($5)==1&&length($4)==1){print $0}}}' >  single_vcf/${i}_NLR_cds_biallelic.vcf
#    vcftools --vcf  single_vcf/${i}_NLR_cds_biallelic.vcf --TajimaD 1 --out single_vcf/${i}_NLR_cds_biallelic.vcf
#    vcftools --vcf  single_vcf/${i}_NLR_cds_biallelic.vcf --site-pi --out single_vcf/${i}_NLR_cds_biallelic.vcf
#done


#### non-single-copy OG 
#rm -rf nonsingle_vcf; mkdir nonsingle_vcf
#grep -v 'Cluster' 52_potato_nonsingle-copy_OG.tsv | awk '{print $1}' | while read i
#do
#    ref=`ls nonsingle_og_cds/${i}/*.fa | awk 'NR==1'`
#    echo -e "chr01\t1\t15000\t$ref\t0\t+" > ${i}_ref.bed
#	echo -e """#!/bin/bash
#	n=1
#    ls nonsingle_og_cds/${i}/*.fa | awk 'NR!=1' | while read query
#    do
##        cat $ref \$query > ${i}_tmp.fa
##        mafft --thread 1 --auto ${i}_tmp.fa > nonsingle_og_cds/${i}/${i}_\${n}.out
##        ./output_one_line_fasta.py nonsingle_og_cds/${i}/${i}_\${n}.out > nonsingle_og_cds/${i}/t && mv nonsingle_og_cds/${i}/t nonsingle_og_cds/${i}/${i}_\${n}.out
#        ./MSA2vcf.py nonsingle_og_cds/${i}/${i}_\${n}.out ${i}_ref.bed $ref \$query nonsingle_og_cds/${i}/${i}_\${n}.out.vcf
#        bgzip -f nonsingle_og_cds/${i}/${i}_\${n}.out.vcf
#        tabix -f -p vcf nonsingle_og_cds/${i}/${i}_\${n}.out.vcf.gz
#        n=\`expr \$n + 1\`
#    done
#    vcf=\`ls nonsingle_og_cds/${i}/${i}*.out.vcf.gz\`
#    bcftools merge -m all --threads 1 \$vcf | bcftools view -v snps > nonsingle_vcf/${i}_NLR_cds.vcf
#    bcftools norm -m -any nonsingle_vcf/${i}_NLR_cds.vcf | awk '{if(\$1~/#/){print \$0}else{if(length(\$5)==1&&length(\$4)==1){print \$0}}}' >  nonsingle_vcf/${i}_NLR_cds_biallelic.vcf
#    vcftools --vcf  nonsingle_vcf/${i}_NLR_cds_biallelic.vcf --TajimaD 1 --out nonsingle_vcf/${i}_NLR_cds_biallelic.vcf
#    vcftools --vcf  nonsingle_vcf/${i}_NLR_cds_biallelic.vcf --site-pi --out nonsingle_vcf/${i}_NLR_cds_biallelic.vcf
#	""" > ${i}.sh && chmod 755 ${i}.sh
#	sbatch -J Ta${i} -p gpu -N 1 --ntasks-per-node=1 -e %x.err -o %x.out "./${i}.sh"	
#done
#


####### summary
#echo -e "OG\tTajima'sD\tNucleotide_diversity" > 52_potato_single-copy_OG_tajimasD_pi.xls
#grep -v 'Cluster' 52_potato_single-copy_OG.tsv | awk '{print $1}' | while read i
#do
#    tajimasd=`grep -v 'CHROM' single_vcf/${i}_NLR_cds_biallelic.vcf.Tajima.D | grep -v 'nan' | awk '{i+=$NF}END{print i/NR}'` 
#    pi=`grep -v 'CHROM' single_vcf/${i}_NLR_cds_biallelic.vcf.sites.pi | grep -v 'nan' | awk '{i+=$NF}END{print i/NR}'` 
#    echo -e "${i}\t${tajimasd}\t${pi}" >> 52_potato_single-copy_OG_tajimasD_pi.xls
#done
#    
#    
#echo -e "OG\tTajima'sD\tNucleotide_diversity" > 52_potato_nonsingle-copy_OG_tajimasD_pi.xls
#grep -v 'Cluster' 52_potato_nonsingle-copy_OG.tsv | awk '{print $1}' | while read i
#do
#    tajimasd=`grep -v 'CHROM' nonsingle_vcf/${i}_NLR_cds_biallelic.vcf.Tajima.D | grep -v 'nan' | awk '{i+=$NF}END{print i/NR}'` 
#    pi=`grep -v 'CHROM' nonsingle_vcf/${i}_NLR_cds_biallelic.vcf.sites.pi | grep -v 'nan' | awk '{i+=$NF}END{print i/NR}'` 
#    echo -e "${i}\t${tajimasd}\t${pi}" >> 52_potato_nonsingle-copy_OG_tajimasD_pi.xls
#done


####### single-copy OG cds alignment for HyPhy

source /home/huyong/software/anaconda3/bin/activate collinerity

rm -rf single_og_alignment; mkdir single_og_alignment
grep -v 'Cluster' 52_potato_single-copy_OG.tsv | awk '{print $1}' | while read i
do
    cat single_og_cds/${i}/*fa > ${i}_cds.fa
    mafft --thread 52 --auto ${i}_cds.fa > single_og_alignment/${i}_cds.out
done

