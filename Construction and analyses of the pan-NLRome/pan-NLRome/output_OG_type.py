#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # 52_potato_matrix_core_dispensable_genes.cluster

nlr = ['CNL', 'TNL', 'NL', 'RNL']
for line in i1:
	if 'Cluster' not in line:
		line = line.strip().split('\t')
		cnl = 0
		tnl = 0
		nl = 0
		rnl = 0
		total = 0
		for n in range(1, len(line)):
			for k in line[n].split(','):
				total += 1
				if '_NLR_CNL' in k:
					cnl += 1
				elif '_NLR_CN' in k:
					cnl += 1
				elif '_NLR_CCX' in k:
					cnl += 1
				elif '_NLR_TNL' in k:
					tnl += 1
				elif '_NLR_TN' in k:
					tnl += 1
				elif '_NLR_TX' in k:
					tnl += 1
				elif '_NLR_NL' in k:
					nl += 1
				elif '_NLR_NBS' in k:
					nl += 1
				elif '_NLR_RNL' in k:
					rnl += 1
		l = [cnl, tnl, nl, rnl]
		og_type = nlr[l.index(max(l))]
		#print(line[0], og_type, sep='\t')
		print(cnl, tnl, nl, rnl, line[0], og_type, sep='\t')

