#!/bin/bash

sed -n '6871,6896p' Solanum_jamesii.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"1","red"}else{print $4,$1,$2,$3,$6,"1","blue"}}' > Solanum_jamesii.prf.bed
sed -n '17173,17205p' Solanum_cardiophyllumC509.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"2","red"}else{print $4,$1,$2,$3,$6,"2","blue"}}' > Solanum_cardiophyllumC509.prf.bed
sed -n '16674,16692p' Solanum_chacoense.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"3","red"}else{print $4,$1,$2,$3,$6,"3","blue"}}' > Solanum_chacoense.prf.bed
sed -n '21148,21163p' Solanum_cajamarquenseC534.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"4","red"}else{print $4,$1,$2,$3,$6,"4","blue"}}' > Solanum_cajamarquenseC534.prf.bed
sed -n '36873,36887p' Solanum_neorossii.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"5","red"}else{print $4,$1,$2,$3,$6,"5","blue"}}' > Solanum_neorossii.prf.bed
sed -n '15790,15810p' Solanum_candolleanum.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"6","red"}else{print $4,$1,$2,$3,$6,"6","blue"}}' > Solanum_candolleanum.prf.bed
sed -n '27587,27605p' Solanum_tuberosum_phurejaC118.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"7","red"}else{print $4,$1,$2,$3,$6,"7","blue"}}' > Solanum_tuberosum_phurejaC118.prf.bed
sed -n '22665,22683p' Solanum_tuberosum_stenotomumC093.bed |awk 'BEGIN{OFS="\t"}{if($4~/_NLR_/){print $4,$1,$2,$3,$6,"8","red"}else{print $4,$1,$2,$3,$6,"8","blue"}}' > Solanum_tuberosum_stenotomumC093.prf.bed

######### reverse compliment these species to avoid inversions
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,10788641-$4,10788641-$3,"-",$6,$7}else{print $1,$2,10788641-$4,10788641-$3,"+",$6,$7}}' Solanum_cardiophyllumC509.prf.bed > Solanum_cardiophyllumC509.prf.reverse.bed && mv Solanum_cardiophyllumC509.prf.bed Solanum_cardiophyllumC509.prf.bed2
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,27025086-$4,27025086-$3,"-",$6,$7}else{print $1,$2,27025086-$4,27025086-$3,"+",$6,$7}}' Solanum_cajamarquenseC534.prf.bed > Solanum_cajamarquenseC534.prf.reverse.bed && mv Solanum_cajamarquenseC534.prf.bed Solanum_cajamarquenseC534.prf.bed2
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,13537352-$4,13537352-$3,"-",$6,$7}else{print $1,$2,13537352-$4,13537352-$3,"+",$6,$7}}' Solanum_neorossii.prf.bed > Solanum_neorossii.prf.reverse.bed && mv Solanum_neorossii.prf.bed Solanum_neorossii.prf.bed2
awk 'BEGIN{OFS="\t"}{if($5=="+"){print $1,$2,28853671-$4,28853671-$3,"-",$6,$7}else{print $1,$2,28853671-$4,28853671-$3,"+",$6,$7}}' Solanum_tuberosum_phurejaC118.prf.bed > Solanum_tuberosum_phurejaC118.prf.reverse.bed && mv Solanum_tuberosum_phurejaC118.prf.bed Solanum_tuberosum_phurejaC118.prf.bed2

rm prf_8_potato.bed
cat *.prf*bed > prf_8_potato.bed

rm prf_aln_region.xls
./output_two_spe_aln_4_plot.py Solanum_jamesii.prf.bed Solanum_cardiophyllumC509.prf.reverse.bed Solanum_jamesii Solanum_cardiophyllumC509 Solanum_jamesii_Solanum_cardiophyllumC509.one2one 2 >> prf_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_cardiophyllumC509.prf.reverse.bed Solanum_chacoense.prf.bed Solanum_cardiophyllumC509 Solanum_chacoense Solanum_cardiophyllumC509_Solanum_chacoense.one2one 3 >> prf_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_chacoense.prf.bed Solanum_cajamarquenseC534.prf.reverse.bed Solanum_chacoense Solanum_cajamarquenseC534 Solanum_chacoense_Solanum_cajamarquenseC534.one2one 4 >> prf_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_cajamarquenseC534.prf.reverse.bed Solanum_neorossii.prf.reverse.bed Solanum_cajamarquenseC534 Solanum_neorossii Solanum_cajamarquenseC534_Solanum_neorossii.one2one 5 >> prf_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_neorossii.prf.reverse.bed Solanum_candolleanum.prf.bed Solanum_neorossii Solanum_candolleanum Solanum_neorossii_Solanum_candolleanum.one2one 6 >> prf_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_candolleanum.prf.bed Solanum_tuberosum_phurejaC118.prf.reverse.bed Solanum_candolleanum Solanum_tuberosum_phurejaC118 Solanum_candolleanum_Solanum_tuberosum_phurejaC118.one2one 7 >> prf_aln_region.xls

./output_two_spe_aln_4_plot.py Solanum_tuberosum_phurejaC118.prf.reverse.bed Solanum_tuberosum_stenotomumC093.prf.bed Solanum_tuberosum_phurejaC118 Solanum_tuberosum_stenotomumC093 Solanum_tuberosum_phurejaC118_Solanum_tuberosum_stenotomumC093.one2one 8 >> prf_aln_region.xls



