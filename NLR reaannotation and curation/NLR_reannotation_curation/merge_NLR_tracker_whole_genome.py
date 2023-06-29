#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # tmp gff3
i2 = open(sys.argv[2])  # ${i}_NLR_class_summary_NLRtracker.xls
i3 = open(sys.argv[3])  # ${i}_NLR_class_summary_whole_genome.xls

gff = {}
for line in i1:
	if line.strip() != '':
		line = line.strip().split()
		if line[2] == 'mRNA':
			gff[line[-1].split(';')[0].split('=')[1]] = [line[0], int(line[3]), int(line[4])]

nlr_tracker = {}
for line in i2:
	if line.strip() != '':
		line = line.strip().split()
		if line[0] in gff:
			nlr_tracker[line[0]] = [line[1], line[2]]

nlr_whole = {}
for line in i3:
	if line.strip() != '':
		line = line.strip().split()
		if line[0] in gff:
			nlr_whole[line[0]] = [line[1], line[2]]

nlr_whole_retain = {}
for k in nlr_whole:
	chro = gff[k][0]
	start = gff[k][1]
	end = gff[k][2]
	f = 0
	for j in nlr_tracker:
		if gff[j][0] == chro:
			if set(range(start, end)) & set(range(gff[j][1], gff[j][2])):
				f += 1
	if not f:
		nlr_whole_retain[k] = ''

for k in nlr_tracker:
	print(k, nlr_tracker[k][0], nlr_tracker[k][1], sep='\t')

for k in nlr_whole_retain:
	print(k, nlr_whole[k][0], nlr_whole[k][1], sep='\t')
