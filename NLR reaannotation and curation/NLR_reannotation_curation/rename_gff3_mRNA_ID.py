#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # gff3
i2 = open(sys.argv[2])  # corres

corres = {}
for line in i2:
	line = line.strip().split()
	corres[line[0]] = line[1]

for line in i1:
	line = line.strip()
	id = line.split('\t')[-1].split(';')[0].split('=')[1]
	if line.split()[2] != "gene" and id in corres:
		print(line.replace(id, corres[id]))
	elif line.split()[2] == "gene" and (id+'.1' in corres or id in corres):
		print(line)
	else:
		pass

