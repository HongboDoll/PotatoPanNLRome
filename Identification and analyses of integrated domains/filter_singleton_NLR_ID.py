#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # 9_tomato_NLRSD_stat_matrix.xls
i2 = open(sys.argv[2])  # 9_tomato_NLRSD_gene_stat_matrix.xls
o1 = open(sys.argv[3],'w')  # 9_tomato_NLRSD_stat_matrix.filterSingleton.xls
o2 = open(sys.argv[4],'w')  # 9_tomato_NLRSD_gene_stat_matrix.filterSingleton.xls

exclude = {}
for line in i2:
    if 'Domains' not in line:
        n = 0
        line = line.strip().split()
        for k in line[1:]:
            n += int(k)
        if n <= 1:
            exclude[line[0]] = ''
i2.seek(0)

for line in i1:
    if 'Domains' not in line:
        line = line.strip().split()
        if line[0] not in exclude:
            o1.write('%s\n' % ('\t'.join(line)))
    else:
        o1.write('%s\n' % line.strip())

for line in i2:
    if 'Domains' not in line:
        line = line.strip().split()
        if line[0] not in exclude:
            o2.write('%s\n' % ('\t'.join(line)))
    else:
        o2.write('%s\n' % line.strip())

