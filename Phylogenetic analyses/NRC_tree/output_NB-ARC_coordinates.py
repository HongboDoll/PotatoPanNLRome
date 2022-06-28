#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # C534_CNL_CN_TNL_TN_domain.xls

domain = {}
for line in i1:
    line = line.strip().split('\t')
    gene = line[0]
    coordinate = []
    for k in line[1].split('~'):
        if 'NB-ARC' in k:
            start = int(k.split(',')[0].split('=')[1])
            end = int(k.split(',')[1].split('=')[1])
            coordinate.append([start, end])
    if len(coordinate) > 1:
        domain[gene] = [coordinate[0][0], coordinate[-1][1]]
    else:
        domain[gene] = [coordinate[0][0], coordinate[0][1]]

for k in domain:
    print(k, domain[k][0], domain[k][1], sep='\t')

