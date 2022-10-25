#!/usr/bin/env python3

import sys,re,math

i1 = open(sys.argv[1])  # pangenome_matrix_4_extract_core_dispensable.xls
o1 = open(sys.argv[2],'w')  # core_list	  conserved in all samples
o2 = open(sys.argv[3],'w')  # soft-core_list 95% of all samples
o3 = open(sys.argv[4],'w')  # shell_list others
o4 = open(sys.argv[5],'w')  # specific_list  accession-specfic

d = {}
for line in i1:
	if 'Cluster' not in line:
		line = line.strip().split()
		m = 0
		for n in range(1, len(line)):
			if str(line[n]) != '-':
				m += 1
		r = re.search('fna\.\d', line[0])
		if m >= (len(line) - 1):  # core
			if not r:
				o1.write('%s\n' % line[0][0:])
			else:
				o1.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
		elif m >= math.floor(0.95*(len(line) - 1)) and m != (len(line) - 1): # soft-core 0.95*number of sample
			if not r:
				o2.write('%s\n' % line[0][0:])
			else:
				o2.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
		elif m == 1: # accessions-specific only present in one sample
			if not r:
				o4.write('%s\n' % line[0][0:])
			else:
				o4.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
		else: # the others are shell
			if not r:
				o3.write('%s\n' % line[0][0:])
			else:
				o3.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
			

