#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # 52_potato_NLRSD_stat.xls

freq = {}
spe = {}
for line in i1:
	line = line.strip().split('\t')
	spe[line[0]] = ''
	if line[1] not in freq:
		freq[line[1]] = {}
		if line[0] not in freq[line[1]]:
			freq[line[1]][line[0]] = 0
			freq[line[1]][line[0]] += int(line[2])
		else:
			freq[line[1]][line[0]] += int(line[2])
	else:
		if line[0] not in freq[line[1]]:
			freq[line[1]][line[0]] = 0
			freq[line[1]][line[0]] += int(line[2])
		else:
			freq[line[1]][line[0]] += int(line[2])

print('Domains', end='\t')
for n in sorted(list(spe)):
	print(n, end='\t')
print('')
	
for k in freq:
	print(k, end='\t')
	for n in sorted(list(spe)):
		if n in freq[k]:
			print(freq[k][n], end='\t')
		else:
			print(0, end='\t')
	print('')



