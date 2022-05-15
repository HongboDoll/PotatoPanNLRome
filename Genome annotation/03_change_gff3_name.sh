#!/bin/bash

for spe in Solanum_cajamarquenseC534 Solanum_candolleanumC400 Solanum_cardiophyllumC509 Solanum_chacoenseC555 Solanum_commersoniiC672 Solanum_dolichocremastrumC850 Solanum_hintoniiC871
do
    cd $spe
    ref2=*_hifiasm.purged.filter.fa
    maker_AED_rename_ch.pl -n ${spe}_ -gff C*.purged.filter.gff3 && mv AED_1.maker.gff ${spe}.purged.filter.rename.gff3
    write_fasta_from_gff.pl --fasta $ref2 --gff ${spe}.purged.filter.rename.gff3 --type=protein --output ${spe}.purged.filter.pep.fa
    cd -
done

