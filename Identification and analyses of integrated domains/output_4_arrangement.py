#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # 52_potato_ID_NLR_4_kaks.xls
i2 = open(sys.argv[2])  # 52_potato_ID_nonNLR_4_kaks.xls
id_domain = str(sys.argv[3])  # AAA_15
o1 = open(sys.argv[4], 'w')  # output1
o2 = open(sys.argv[5], 'w')  # output2


spe1 = []
n = 0
for line in i1:
	if 'Domain' not in line:
		line = line.strip().split()
		if line[0] == id_domain:
			for k in range(1, len(line)):
				if line[k] != '-':
					n += 1
					spe1.append(k)
i1.seek(0)
spe2 = []
n = 0
for line in i2:
	if 'Domain' not in line:
		line = line.strip().split()
		if line[0] == id_domain:
			for k in range(1, len(line)):
				if line[k] != '-':
					n += 1
					spe2.append(k)
i2.seek(0)
spe = set(spe1)&set(spe2)

if len(spe) >= 4:
	spe_gene2 = []
	for line in i2:
		if 'Domain' not in line:
			line = line.strip().split()
			if line[0] == id_domain:
				for k in range(1, len(line)):
					if line[k] != '-' and k in spe:
						spe_gene2.append(line[k])
	spe_gene = []
	for line in i1:
		if 'Domain' not in line:
			line = line.strip().split()
			if line[0] == id_domain:
				for k in range(1, len(line)):
					if line[k] != '-' and k in spe:
						spe_gene.append(line[k])


	for nn in range(0, len(spe_gene)):
		if nn != (len(spe_gene) - 1):
			if spe_gene[nn].count(',') == 1:
				o1.write('%s,' % (spe_gene[nn].replace(',', '')))
			elif spe_gene[nn].count(',') > 1:
				spe_gene[nn] = spe_gene[nn].split(',')
				for n in range(0, len(spe_gene[nn])-1):
					o1.write('%s,' % (spe_gene[nn][n]))
		elif nn == (len(spe_gene) - 1):
			if spe_gene[nn].count(',') == 1:
				o1.write('%s\n' % (spe_gene[nn].replace(',', '')))
			elif spe_gene[nn].count(',') > 1:
				spe_gene[nn] = spe_gene[nn].split(',')
				for n in range(0, len(spe_gene[nn])-1):
					if n != (len(spe_gene[nn]) - 2):
						o1.write('%s,' % (spe_gene[nn][n]))
					elif n == (len(spe_gene[nn]) - 2):
						o1.write('%s\n' % (spe_gene[nn][n]))

	for nn in range(0, len(spe_gene2)):
		if nn != (len(spe_gene2) - 1):
			if spe_gene2[nn].count(',') == 1:
				o2.write('%s,' % (spe_gene2[nn].replace(',', '')))
			elif spe_gene2[nn].count(',') > 1:
				spe_gene2[nn] = spe_gene2[nn].split(',')
				for n in range(0, len(spe_gene2[nn])-1):
					o2.write('%s,' % (spe_gene2[nn][n]))
		elif nn == (len(spe_gene2) - 1):
			if spe_gene2[nn].count(',') == 1:
				o2.write('%s\n' % (spe_gene2[nn].replace(',', '')))
			elif spe_gene2[nn].count(',') > 1:
				spe_gene2[nn] = spe_gene2[nn].split(',')
				for n in range(0, len(spe_gene2[nn])-1):
					if n != (len(spe_gene2[nn]) - 2):
						o2.write('%s,' % (spe_gene2[nn][n]))
					elif n == (len(spe_gene2[nn]) - 2):
						o2.write('%s\n' % (spe_gene2[nn][n]))

