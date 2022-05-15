#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # Orthogroups.GeneCount.tsv
i2 = int(sys.argv[2])   # number of species have OG member number = 1

for line in i1:
	if 'Orthogroup' in line:
		print(line.strip())
	else:
		line = line.strip().split()
		count = 0
		for n in range(1, len(line)-1):
			if line[n] == '1':
				count += 1
		if count >= i2:
			print('\t'.join(line))

