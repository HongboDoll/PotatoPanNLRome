#!/bin/bash
    rm -rf OG0000102
    cat nonsingle_og_cds/OG0000102/*fa > OG0000102_cds.fa
    cat OG0000102_cds.fa|grep '>'|sed 's/>//g'|sed ':a;N;s/\n/ /g;ta' > OG0000102_arrangement
    ParaAT_merely_codon_alignment.pl -h OG0000102_arrangement -n all_NLR_cds.fa -a all_NLR_pep.fa -p proc -o OG0000102 -m muscle -f fasta && mv OG0000102/tmpttt.cds_aln.fasta nonsingle_og_codon_alignment/OG0000102_codon.out
    rm -rf OG0000102
    ParaAT_merely_codon_alignment.pl -h OG0000102_arrangement -n all_NLR_cds.fa -a all_NLR_pep.fa -p proc -o OG0000102 -m muscle -f axt -kaks && mv OG0000102/tmpttt.cds_aln.axt.kaks nonsingle_og_codon_alignment/OG0000102.kaks
    rm -rf OG0000102
	
