#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # results/Solanum_andreanum/*filter.txt
i2 = open(sys.argv[2])  # results_whole_genome/Solanum_andreanum/*.verbose
id_name = str(sys.argv[3])  # AAA_16
spe = str(sys.argv[4])  # Solanum_andreanum
o1 = open(sys.argv[5], 'w')  # output1
o2 = open(sys.argv[6], 'w')  # output2

n = 0
for line in i1:
	line = line.strip().split('\t')
	for k in line[1].split('~'):
		if id_name+'(' in k:
			n += 1
			gene = line[0]
			start = k.split('start=')[1].split(',')[0]
			end = k.split('stop=')[1].split(',')[0]
			o1.write('%s,' % (gene+':'+start+'-'+end))
if n:
	o1.write('\n')
else:
	o1.write('-\n')

n = 0
for line in i2:
	if '_NLR' not in line and 'NB-' not in line:
		line = line.strip().split('\t')
		for k in line[1].split('~'):
			if id_name+'(' in k and float(k.split('evalue=')[1].split(')')[0]) < 0.001:
				n += 1
				gene = line[0]
				start = k.split('start=')[1].split(',')[0]
				end = k.split('stop=')[1].split(',')[0]
				o2.write('%s,' % (gene+':'+start+'-'+end))
if n:
	o2.write('\n')
else:
	o2.write('-\n')

