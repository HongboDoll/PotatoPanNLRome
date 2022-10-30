#!/bin/bash

cat 50_acc_dmv6.1_snp.vcf|grep '#CHROM'|cut -f '10-10000'|sed 's/\t/\n/g' > accession_list.xls
ls split_phenotypes/*txt | while read i
do 
	awk '{print $1,$1,$2}' $i > ${i}.xls
	./convert_order_pheno_formart_2_emmax.py accession_list.xls ${i}.xls > t; mv t ${i}.xls
done

plink --vcf 50_acc_dmv6.1_snp.vcf --recode12 --allow-extra-chr --geno 0.1 --maf 0.05 --allow-no-sex --biallelic-only --out 50_potato

cat 50_potato.map | sed 's/ST4.03ch0//g' | sed 's/ST4.03ch//g' > 50_potato.map2
mv 50_potato.map2 50_potato.map

# PCA
plink --allow-extra-chr --file 50_potato --indep-pairwise 50 5 0.2 --recode vcf-iid --out 50_potato_LDpruned

plink --allow-extra-chr --file 50_potato --recode vcf-iid --extract 50_potato_LDpruned.prune.in --out 50_potato_LDpruned

plink --allow-extra-chr --vcf 50_potato_LDpruned.vcf --make-bed --out 50_potato_LDpruned_bfile

plink --bfile 50_potato_LDpruned_bfile --allow-extra-chr --allow-no-sex --pca 10 --out PCA

cat PCA.eigenvec | awk '{print $1,$2,"1",$3,$4,$5,$6,$7}' > PCA.txt

# GEC: 1.70E-7 Suggestive_P_Value
plink --file 50_potato --allow-extra-chr --make-bed --out 50_potato
java -jar /public/agis/huangsanwen_group/lihongbo/software/gec.jar -Xmxlg --effect-number --plink-binary ./50_potato --genome --no-web --out 50_potato.gec
threshold=`grep -v "Observed_Number" 50_potato.gec.sum | awk '{print $4}'`


# EMMAX
plink --file 50_potato --allow-extra-chr --recode 12 --output-missing-genotype 0 --transpose --out 50_potato

emmax-kin -v -d 10 50_potato

ls split_phenotypes/*xls | while read i
do
trait=`echo $i | awk -F '/' '{print $2}' | awk -F '.' '{print $1}'`
emmax -v -d 10 -t 50_potato \
        -p $i \
        -k 50_potato.aBN.kinf \
        -c PCA.txt \
        -o $trait

cat 50_potato.map | paste - ${trait}.ps | awk '{print $2,$1,$4,$8}' | sed '1i\SNP CHR BP P' | sed 's/ /\t/g' > ${trait}.50_potato.out.txt

./manhattan_qq.R ${trait}.50_potato.out.txt ${trait}_EMMAX_aBN.ps.png $threshold
done

