#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # paired_results/${i}.paired.txt
i2 = open(sys.argv[2])  # ../clustered_NLR/clustered_results/${i}.clustered.txt

cluster = {}
for line in i2:
    line = line.strip().split()
    for k in line[4].split(','):
        cluster[k] = ''

for line in i1:
    if '#CHRO' not in line:
        line = line.strip().split()
        if line[3] in cluster or line[9] in cluster:
            pass
        else:
            print('\t'.join(line))
    else:
        print(line.strip())

