#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # removemRNA
i2 = open(sys.argv[2])  # tmp.gff3

remove = {}
for line in i1:
    remove[line.strip()] = ''

for line in i2:
    line = line.strip().split()
    name = line[-1].split(';')[0].split('=')[1]
    if name not in remove:
        print('\t'.join(line))

