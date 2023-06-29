#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # Anisodus_luridush.filter.NLR.pep.fa
i2 = open(sys.argv[2])  # Anisodus_luridush_NLR_class_summary.xls

corres = {}
for line in i2:
	line = line.strip().split()
	corres[line[0]] = line[2]	
def read_fasta(fasta):
	scaf = {}     # to calculate the length of each scaffold
	name = ''
	seq= ''
	a=0
	for line in fasta:
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
	return scaf

scaf = read_fasta(i1)

for k in scaf:
	if k in corres:
		kk = k+'_NLR_'+corres[k]
		print('>'+kk)
		print(scaf[k])

