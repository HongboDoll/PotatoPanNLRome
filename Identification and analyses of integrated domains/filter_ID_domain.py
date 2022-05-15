#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # Solanum_tuberosumRH1015_pfamscan.parsed.verbose.NLRSD.txt
o1 = open(sys.argv[2], 'w')  # output stat for NLR ID frequency
o2 = open(sys.argv[3], 'w')  # output stat for NLR ID gene frequency

freq = {}
freqGene = {}
for line in i1:
	line = line.strip().split('\t')
	domain = []
	gene = {}
	for k in line[-1].split('~'):
		if 'NB-ARC' not in k and 'NLR' not in k and 'LRR' not in k and 'NB-LRR' not in k and 'TIR' not in k and 'RPW8' not in k and 'Rx_N' not in k:
			domain.append(k.split('(')[0])
			gene[k.split('(')[0]] = line
#	print(gene)
	if domain:
		print('\t'.join(line))
		for n in domain:
			if n not in freq:
				freq[n] = 0
				freq[n] += 1
			else:
				freq[n] += 1
	if gene:
		for n in gene:
			if n not in freqGene:
				freqGene[n] = 0
				freqGene[n] += 1
			else:
				freqGene[n] += 1	
for k in freq:
	o1.write('%s\t%s\n' % (k, freq[k]))
	
for k in freqGene:
	o2.write('%s\t%s\n' % (k, freqGene[k]))


