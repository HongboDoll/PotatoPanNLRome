#!/usr/bin/env python3

import sys,re,math

i1 = open(sys.argv[1])  # pangenome_matrix_4_extract_core_dispensable.xls
o2 = open(sys.argv[2],'w')  # core_list	  present in >= 95% samples
o3 = open(sys.argv[3],'w')  # shell_list 5% - 95%
o4 = open(sys.argv[4],'w')  # cloud_list  <=5%

d = {}
for line in i1:
	if 'Cluster' not in line:
		line = line.strip().split()
		m = 0
		for n in range(1, len(line)):
			if str(line[n]) != '-':
				m += 1
		r = re.search('fna\.\d', line[0])
		#if m >= (len(line) - 1):  # core
	#		if not r:
#				o1.write('%s\n' % line[0][0:])
#			else:
#				o1.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
		if m >= math.floor(0.95*(len(line) - 1)): # soft-core 0.95*number of sample
			if not r:
				o2.write('%s\n' % line[0][0:])
			else:
				o2.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
			print('core'+line[0], m, sep='\t')
		elif m <= math.floor(0.05*(len(line) - 1)): # cloud only present in one sample
			if not r:
				o4.write('%s\n' % line[0][0:])
			else:
				o4.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
			print('cloud'+line[0], m, sep='\t')
		elif m > math.floor(0.05*(len(line) - 1)) and m < math.floor(0.95*(len(line) - 1)): # the others are shell
			if not r:
				o3.write('%s\n' % line[0][0:])
			else:
				o3.write('%s\n' % line[0][0:-2].replace('fna.','fna'))
			print('shell'+line[0], m, sep='\t')
			

