#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # tmp gff3
i2 = open(sys.argv[2])  # ${i}_NLR_class_summary.xls
i3 = open(sys.argv[3])  # corres

corres = {}
corres_gene = {}
for line in i3:
	line = line.strip().split()
	corres[line[0]] = line[1]
	corres_gene['.'.join(line[0].split('.')[:-1])] = line[1]
nlr = {}
nlr_gene = {}
for line in i2:
	line = line.strip().split()
	nlr[line[0]] = ''
	nlr_gene['.'.join(line[0].split('.')[:-1])] = ''
for line in i1:
	line = line.strip()
	ida = line.split('\t')[-1].split(';')[0].split('=')[1]
	if ida in nlr or ida in nlr_gene:
		if line.split()[2] != "gene" and ida in corres:
			print(line.replace(ida, corres[ida]))
		elif line.split()[2] == "gene" and ida in corres_gene:
			#print(line.replace(ida, corres_gene[ida]))
			print(line.strip())
		else:
			pass


