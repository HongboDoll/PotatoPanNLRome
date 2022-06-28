#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # 52_potato_nonsingle-copy_OG.tsv

for line in i1:
	line = line.strip().split()
	n = 0
	for k in range(1, len(line)):
		for j in line[k].split(','):
			if j != '-':
				n += 1
	if n >= 4:
		print('\t'.join(line))

