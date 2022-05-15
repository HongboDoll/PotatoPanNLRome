#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # accession_list.xls
i2 = open(sys.argv[2])  # flowering_time.pheno1

acc = []
for line in i1:
	acc.append(line.strip())

d = {}
for line in i2:
	line = line.strip().split()
	d[line[0]] = line[2]

for k in acc:
	if k in d:
		print(k, k, d[k])
	else:
		print(k, k, 'NA')

