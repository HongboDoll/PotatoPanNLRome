#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # fasta

scaf = {}     # to calculate the length of each scaffold
name = ''
seq= ''
a=0
for line in i1:
    line=line.strip()
    if '>' in line:
        scaf[name] = seq
        seq = ''
        name = line[1:]
        a = 1
        continue
    elif a and '>' not in line:
        seq += line
scaf[name] = seq
scaf.pop('')

for k in scaf:
    print('>'+k)
    print(scaf[k])

