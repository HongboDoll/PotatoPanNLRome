#!/bin/bash

#cat spe_list.xls | grep -v '#' | while read n
#do
#i1=`echo $n | awk '{print $1}'`
#i2=`echo $n | awk '{print $2}'`
#i=`echo 1 | awk '{print "'"$i1"'"".""'"$i2"'"}'`
#rm -rf $i; mkdir $i
#cd $i
#ln -s ../${i1}* .
#ln -s ../${i2}* .
#echo -e """#!/bin/bash
#/home/huyong/software/genetribe/genetribe core -l ${i1} -f ${i2} -n 52 -s ~
#
#""" > ${i}.genetribe.sh && chmod 755 ${i1}.${i2}.genetribe.sh
#cd -
#done
##
##    cat Solanum_americanum.integratedNLR.gff3|awk '$3=="mRNA"'|awk 'BEGIN{OFS="\t"}{split($9,a,";");print $1,$4,$5,a[1],"0",$7}'|sed 's/ID=//g' | sort -k1,1 -k2,2n > Solanum_americanum.bed
##    echo "N" > Solanum_americanum.chrlist
#
#cat spe_list.xls | grep -v '#' | while read n
#do
#i1=`echo $n | awk '{print $1}'`
#i2=`echo $n | awk '{print $2}'`
#i=`echo 1 | awk '{print "'"$i1"'"".""'"$i2"'"}'`
#	cd $i
#    sbatch -J ${i1}.${i2}.genetribe -p queue1 --qos=queue1 -N 1 --ntasks-per-node=52 -e %x.err -o %x.out "./${i1}.${i2}.genetribe.sh"
#	cd -
#done

sed -n '33870,33929p' Solanum_americanum.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"1","yellow"}else{print $4,$1,$2,$3,$6,"1","blue"}}' > Solanum_americanum.card1.bed
sed -n '22684,22721p' Solanum_cardiophyllumC509.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"2","yellow"}else{print $4,$1,$2,$3,$6,"2","blue"}}' > Solanum_cardiophyllumC509.card1.bed
sed -n '11598,11636p' Solanum_jamesii.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"3","yellow"}else{print $4,$1,$2,$3,$6,"3","blue"}}' > Solanum_jamesii.card1.bed
sed -n '31926,31978p' Solanum_chacoense.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"4","yellow"}else{print $4,$1,$2,$3,$6,"4","blue"}}' > Solanum_chacoense.card1.bed
sed -n '26645,26677p' Solanum_cajamarquenseC534.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"5","yellow"}else{print $4,$1,$2,$3,$6,"5","blue"}}' > Solanum_cajamarquenseC534.card1.bed
sed -n '26668,26717p' Solanum_neorossii.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"6","yellow"}else{print $4,$1,$2,$3,$6,"6","blue"}}' > Solanum_neorossii.card1.bed
sed -n '12079,12123p' Solanum_candolleanum.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"7","yellow"}else{print $4,$1,$2,$3,$6,"7","blue"}}' > Solanum_candolleanum.card1.bed
sed -n '34720,34767p' Solanum_tuberosum_phurejaC118.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"8","yellow"}else{print $4,$1,$2,$3,$6,"8","blue"}}' > Solanum_tuberosum_phurejaC118.card1.bed
sed -n '29984,30031p' Solanum_tuberosum_stenotomumC093.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"9","yellow"}else{print $4,$1,$2,$3,$6,"9","blue"}}' > Solanum_tuberosum_stenotomumC093.card1.bed

######### reverse compliment these species to avoid inversions
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,18129784-$4,18129784-$3,"-",$6,$7}else{print $1,$2,18129784-$4,18129784-$3,"+",$6,$7}}' Solanum_cardiophyllumC509.card1.bed > Solanum_cardiophyllumC509.card1.reverse.bed
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,9147044-$4,9147044-$3,"-",$6,$7}else{print $1,$2,9147044-$4,9147044-$3,"+",$6,$7}}' Solanum_cajamarquenseC534.card1.bed > Solanum_cajamarquenseC534.card1.reverse.bed
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,75809500-$4,75809500-$3,"-",$6,$7}else{print $1,$2,75809500-$4,75809500-$3,"+",$6,$7}}' Solanum_candolleanum.card1.bed > Solanum_candolleanum.card1.reverse.bed
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,12219695-$4,12219695-$3,"-",$6,$7}else{print $1,$2,12219695-$4,12219695-$3,"+",$6,$7}}' Solanum_tuberosum_stenotomumC093.card1.bed > Solanum_tuberosum_stenotomumC093.card1.reverse.bed


mv Solanum_cajamarquenseC534.card1.bed Solanum_cajamarquenseC534.card1.bed2
mv Solanum_candolleanum.card1.bed Solanum_candolleanum.card1.bed2
mv Solanum_cardiophyllumC509.card1.bed Solanum_cardiophyllumC509.card1.bed2
mv Solanum_tuberosum_stenotomumC093.card1.bed Solanum_tuberosum_stenotomumC093.card1.bed2


#cat error_correspondance.xls | while read i
#do
#       name=`echo $i | awk '{print $1}'`
#       move=`echo $i | awk '{print $2}'`
#       sed -i "s/${move}/${name}/g" Solanum_tuberosum_phurejaC118_Solanum_tuberosum_stenotomumC093.one2one
#       sed -i "s/${move}/${name}/g" Solanum_candolleanum_Solanum_tuberosum_phurejaC118.one2one
#done


rm card1_aln_region.xls
./output_two_spe_aln_4_plot.py Solanum_americanum.card1.bed Solanum_cardiophyllumC509.card1.reverse.bed  Solanum_americanum Solanum_cardiophyllumC509   Solanum_americanum_Solanum_cardiophyllumC509.one2one 2 >> card1_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_cardiophyllumC509.card1.reverse.bed Solanum_jamesii.card1.bed  Solanum_cardiophyllumC509 Solanum_jamesii  Solanum_cardiophyllumC509_Solanum_jamesii.one2one 3 >> card1_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_jamesii.card1.bed Solanum_chacoense.card1.bed   Solanum_jamesii   Solanum_chacoense Solanum_jamesii_Solanum_chacoense.one2one 4 >> card1_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_chacoense.card1.bed Solanum_cajamarquenseC534.card1.reverse.bed Solanum_chacoense Solanum_cajamarquenseC534 Solanum_chacoense_Solanum_cajamarquenseC534.one2one 5 >> card1_aln_region.xls
#
./output_two_spe_aln_4_plot.py Solanum_cajamarquenseC534.card1.reverse.bed Solanum_neorossii.card1.bed Solanum_cajamarquenseC534 Solanum_neorossii Solanum_cajamarquenseC534_Solanum_neorossii.one2one 6 >> card1_aln_region.xls
#
./output_two_spe_aln_4_plot.py Solanum_neorossii.card1.bed Solanum_candolleanum.card1.reverse.bed Solanum_neorossii Solanum_candolleanum Solanum_neorossii_Solanum_candolleanum.one2one 7 >> card1_aln_region.xls
#
./output_two_spe_aln_4_plot.py Solanum_candolleanum.card1.reverse.bed Solanum_tuberosum_phurejaC118.card1.bed Solanum_candolleanum Solanum_tuberosum_phurejaC118 Solanum_candolleanum_Solanum_tuberosum_phurejaC118.one2one 8 >> card1_aln_region.xls
#
./output_two_spe_aln_4_plot.py Solanum_tuberosum_phurejaC118.card1.bed Solanum_tuberosum_stenotomumC093.card1.reverse.bed Solanum_tuberosum_phurejaC118 Solanum_tuberosum_stenotomumC093 Solanum_tuberosum_phurejaC118_Solanum_tuberosum_stenotomumC093.one2one 9 >> card1_aln_region.xls

rm card1_8_potato.bed
cat *card1*bed > card1_8_potato.bed

