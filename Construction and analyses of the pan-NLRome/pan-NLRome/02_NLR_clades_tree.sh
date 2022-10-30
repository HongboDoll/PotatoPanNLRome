#!/bin/bash

rm -rf mafft_out_pep; mkdir mafft_out_pep
rm -rf Orthogroup_tree; mkdir Orthogroup_tree
ls $PWD/pep/OrthoFinder/Results_*/Orthogroup_Sequences | head -493 | while read i
#comm -23 allOG  doneOG | while read n
do
#	i=${n}.fa
    echo -e """#!/bin/bash
    source /home/huyong/software/anaconda3/bin/activate collinerity
    
    mafft --thread 1 --maxiterate 1000 $PWD/pep/OrthoFinder/Results_*/Orthogroup_Sequences/${i} > mafft_out_pep/${i}.out
    fa2phy.py -i mafft_out_pep/${i}.out -o mafft_out_pep/${i}.phylip
    iqtree -s mafft_out_pep/${i}.phylip -m MFP -b 100 -safe -nt AUTO -ntmax 1 --prefix Orthogroup_tree/${i}
    """ > ${i}.run.sh && chmod 755 ${i}.run.sh
done

ls *.run.sh | while read i
#comm -23 allOG  doneOG | while read n
do
#	i=${n}.fa
    sbatch -J $i -p low -N 1 --ntasks-per-node=1 -e %x.err -o %x.out "./${i}" 
done

