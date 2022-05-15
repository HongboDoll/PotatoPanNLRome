#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # A157.NLR.2k.gff3
i2 = open(sys.argv[2])  # A157.NLR.2k.all.gff3

d = {}
for line in i1:
	if '#' not in line:
		line = line.strip().split()
		name = line[-1].split('=')[1]
		d[name] = [line[0], line[3], line[4]]

for line in i2:
	line = line.strip().split()
	if line[0] in d:
		print(d[line[0]][0], '\t'.join(line[1:3]), int(line[3])+int(d[line[0]][1])-1,  int(line[4])+int(d[line[0]][1])-1, '\t'.join(line[5:8]), line[8].replace('exonerate_protein2genome-gene-', ''), sep='\t')

