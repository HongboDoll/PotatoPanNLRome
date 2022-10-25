#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # 52_potato_matrix_core_dispensable_genes.cluster.copyNumber.xls
i2 = open(sys.argv[2])  # potato_wild_species.xls
o1 = open(sys.argv[3], 'w')  # num_clades12
o2 = open(sys.argv[4], 'w')  # num_clades34

clades12 = {}
clades34 = {}
for line in i2:
    line = line.strip().split('\t')
    if 'Clades 1+2 wild' == line[1]:
        clades12[line[0]] = ''
    else:
        clades34[line[0]] = ''

clades12_num = {}
clades34_num = {}
for line in i1:
    if 'Copy number' in line:
        line = line.strip().split('\t')
        for k in range(1, 53):
            if line[k] in clades12:
                clades12_num[k+1] = ''
            elif line[k] in clades34:
                clades34_num[k+1] = ''

for k in clades12_num:
    o1.write('%d\n' % k)

for k in clades34_num:
    o2.write('%d\n' % k)

