#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # C400_NLRtracker.tsv
i2 = open(sys.argv[2])  # C400_NLRtracker_whole_genome.tsv
o1 = open(sys.argv[3], 'w')  # purged_output
o2 = open(sys.argv[4], 'w')  # whole_genome_output


c = {'CNL':0, 'TNL':0, 'CN':0, 'NL':0, 'NBS':0, 'TN':0, 'TX':0, 'CCX':0, 'OTHER':0, 'RNL':0}
g = {'CNL':[], 'TNL':[], 'CN':[], 'NL':[], 'NBS':[], 'TN':[], 'TX':[], 'CCX':[], 'OTHER':[], 'RNL':[]}
l = ['CNL', 'CN', 'CCX', 'TNL', 'TN', 'TX', 'RNL', 'NL', 'NBS', 'OTHER']
for line in i1:
	if 'seqname' not in line:
		line = line.strip().split('\t')
		if 'NLR' in line[1]:
			if "RNL" in line[-1] and line[2] == 'CCR-NLR':
				c['RNL'] += 1
				if 'degenerate' in line[1]:
					g['RNL'].append(line[0]+'~'+'degenerate')
				else:
					g['RNL'].append(line[0]+'~'+'normal')
			
			if 'CC-NLR' in line[2]:
				line[-1] = line[-1].replace('P', 'N')
				line[-1] = line[-1].replace('B', 'C')
				if 'CNL' in line[-1]:
					c['CNL'] += 1
					if 'degenerate' in line[1]:
						g['CNL'].append(line[0]+'~'+'degenerate')
					else:
						g['CNL'].append(line[0]+'~'+'normal')
				elif 'CN' in line[-1] and 'L' not in line[-1]:
					c['CN'] += 1
					if 'degenerate' in line[1]:
						g['CN'].append(line[0]+'~'+'degenerate')
					else:
						g['CN'].append(line[0]+'~'+'normal')
				elif 'NL' in line[-1] and 'C' not in line[-1]:
					c['NL'] += 1
					if 'degenerate' in line[1]:
						g['NL'].append(line[0]+'~'+'degenerate')
					else:
						g['NL'].append(line[0]+'~'+'normal')
				elif 'N' in line[-1] and 'L' not in line[-1] and 'C' not in line[-1]:
					c['NBS'] += 1
					if 'degenerate' in line[1]:
						g['NBS'].append(line[0]+'~'+'degenerate')
					else:
						g['NBS'].append(line[0]+'~'+'normal')
				elif 'C' in line[-1] and 'N' not in line[-1] and 'L' not in line[-1]:
					c['CCX'] += 1
					if 'degenerate' in line[1]:
						g['CCX'].append(line[0]+'~'+'degenerate')
					else:
						g['CCX'].append(line[0]+'~'+'normal')

			elif 'TIR-NLR' in line[2]:
				if 'TNL' in line[-1]:
					c['TNL'] += 1
					if 'degenerate' in line[1]:
						g['TNL'].append(line[0]+'~'+'degenerate')
					else:
						g['TNL'].append(line[0]+'~'+'normal')
				else:
					if 'NL' in line[-1] and 'T' not in line[-1]:
						c['NL'] += 1
						if 'degenerate' in line[1]:
							g['NL'].append(line[0]+'~'+'degenerate')
						else:
							g['NL'].append(line[0]+'~'+'normal')
					elif 'N' in line[-1] and 'L' not in line[-1] and 'T' not in line[-1]:
						c['NBS'] += 1
						if 'degenerate' in line[1]:
							g['NBS'].append(line[0]+'~'+'degenerate')
						else:
							g['NBS'].append(line[0]+'~'+'normal')
					elif 'TN' in line[-1] and 'L' not in line[-1]:
						c['TN'] += 1
						if 'degenerate' in line[1]:
							g['TN'].append(line[0]+'~'+'degenerate')
						else:
							g['TN'].append(line[0]+'~'+'normal')
					elif 'T' in line[-1] and 'N' not in line[-1] and 'L' not in line[-1]:
						c['TX'] += 1
						if 'degenerate' in line[1]:
							g['TX'].append(line[0]+'~'+'degenerate')
						else:
							g['TX'].append(line[0]+'~'+'normal')
						
						
			elif line[2] == 'TN (OTHER)':
				c['TN'] += 1
				if 'degenerate' in line[1]:
					g['TN'].append(line[0]+'~'+'degenerate')
				else:
					g['TN'].append(line[0]+'~'+'normal')
			elif line[2] == 'UNDETERMINED':
				line[-1] = line[-1].replace('P', 'N')
				if 'NL' in line[-1] and 'T' not in line[-1] and 'C' not in line[-1]:
					c['NL'] += 1
					if 'degenerate' in line[1]:
						g['NL'].append(line[0]+'~'+'degenerate')
					else:
						g['NL'].append(line[0]+'~'+'normal')
				elif 'N' in line[-1] and 'L' not in line[-1] and 'T' not in line[-1] and 'C' not in line[-1]:
					c['NBS'] += 1
					if 'degenerate' in line[1]:
						g['NBS'].append(line[0]+'~'+'degenerate')
					else:
						g['NBS'].append(line[0]+'~'+'normal')
				elif 'TN' in line[-1] and 'L' not in line[-1]:
					c['TN'] += 1
					if 'degenerate' in line[1]:
						g['TN'].append(line[0]+'~'+'degenerate')
					else:
						g['TN'].append(line[0]+'~'+'normal')
				elif 'TNL' in line[-1]:
					c['TNL'] += 1
					if 'degenerate' in line[1]:
						g['TNL'].append(line[0]+'~'+'degenerate')
					else:
						g['TNL'].append(line[0]+'~'+'normal')
				elif 'CN' in line[-1] and 'L' not in line[-1]:
					c['CN'] += 1
					if 'degenerate' in line[1]:
						g['CN'].append(line[0]+'~'+'degenerate')
					else:
						g['CN'].append(line[0]+'~'+'normal')
				elif 'CNL' in line[-1]:
					c['CNL'] += 1
					if 'degenerate' in line[1]:
						g['CNL'].append(line[0]+'~'+'degenerate')
					else:
						g['CNL'].append(line[0]+'~'+'normal')
		elif line[1] == 'TX':
			c['TX'] += 1
			if 'degenerate' in line[1]:
				g['TX'].append(line[0]+'~'+'degenerate')
			else:
				g['TX'].append(line[0]+'~'+'normal')
		elif line[1] == 'CCX':
			c['CCX'] += 1
			if 'degenerate' in line[1]:
				g['CCX'].append(line[0]+'~'+'degenerate')
			else:
				g['CCX'].append(line[0]+'~'+'normal')

for k in l:
	if k in g:
		for j in g[k]:
			o1.write('%s\t%s\t%s\n' % (j.split('~')[0], j.split('~')[1], k))

c = {'CNL':0, 'TNL':0, 'CN':0, 'NL':0, 'NBS':0, 'TN':0, 'TX':0, 'CCX':0, 'OTHER':0, 'RNL':0}
g = {'CNL':[], 'TNL':[], 'CN':[], 'NL':[], 'NBS':[], 'TN':[], 'TX':[], 'CCX':[], 'OTHER':[], 'RNL':[]}
l = ['CNL', 'CN', 'CCX', 'TNL', 'TN', 'TX', 'RNL', 'NL', 'NBS', 'OTHER']

for line in i2:
	if 'seqname' not in line:
		line = line.strip().split('\t')
		if 'NLR' in line[1]:
			if "RNL" in line[-1] and line[2] == 'CCR-NLR':
				c['RNL'] += 1
				if 'degenerate' in line[1]:
					g['RNL'].append(line[0]+'~'+'degenerate')
				else:
					g['RNL'].append(line[0]+'~'+'normal')
			
			if 'CC-NLR' in line[2]:
				line[-1] = line[-1].replace('P', 'N')
				line[-1] = line[-1].replace('B', 'C')
				if 'CNL' in line[-1]:
					c['CNL'] += 1
					if 'degenerate' in line[1]:
						g['CNL'].append(line[0]+'~'+'degenerate')
					else:
						g['CNL'].append(line[0]+'~'+'normal')
				elif 'CN' in line[-1] and 'L' not in line[-1]:
					c['CN'] += 1
					if 'degenerate' in line[1]:
						g['CN'].append(line[0]+'~'+'degenerate')
					else:
						g['CN'].append(line[0]+'~'+'normal')
				elif 'NL' in line[-1] and 'C' not in line[-1]:
					c['NL'] += 1
					if 'degenerate' in line[1]:
						g['NL'].append(line[0]+'~'+'degenerate')
					else:
						g['NL'].append(line[0]+'~'+'normal')
				elif 'N' in line[-1] and 'L' not in line[-1] and 'C' not in line[-1]:
					c['NBS'] += 1
					if 'degenerate' in line[1]:
						g['NBS'].append(line[0]+'~'+'degenerate')
					else:
						g['NBS'].append(line[0]+'~'+'normal')
				elif 'C' in line[-1] and 'N' not in line[-1] and 'L' not in line[-1]:
					c['CCX'] += 1
					if 'degenerate' in line[1]:
						g['CCX'].append(line[0]+'~'+'degenerate')
					else:
						g['CCX'].append(line[0]+'~'+'normal')

			elif 'TIR-NLR' in line[2]:
				if 'TNL' in line[-1]:
					c['TNL'] += 1
					if 'degenerate' in line[1]:
						g['TNL'].append(line[0]+'~'+'degenerate')
					else:
						g['TNL'].append(line[0]+'~'+'normal')
				else:
					if 'NL' in line[-1] and 'T' not in line[-1]:
						c['NL'] += 1
						if 'degenerate' in line[1]:
							g['NL'].append(line[0]+'~'+'degenerate')
						else:
							g['NL'].append(line[0]+'~'+'normal')
					elif 'N' in line[-1] and 'L' not in line[-1] and 'T' not in line[-1]:
						c['NBS'] += 1
						if 'degenerate' in line[1]:
							g['NBS'].append(line[0]+'~'+'degenerate')
						else:
							g['NBS'].append(line[0]+'~'+'normal')
					elif 'TN' in line[-1] and 'L' not in line[-1]:
						c['TN'] += 1
						if 'degenerate' in line[1]:
							g['TN'].append(line[0]+'~'+'degenerate')
						else:
							g['TN'].append(line[0]+'~'+'normal')
					elif 'T' in line[-1] and 'N' not in line[-1] and 'L' not in line[-1]:
						c['TX'] += 1
						if 'degenerate' in line[1]:
							g['TX'].append(line[0]+'~'+'degenerate')
						else:
							g['TX'].append(line[0]+'~'+'normal')
						
						
			elif line[2] == 'TN (OTHER)':
				c['TN'] += 1
				if 'degenerate' in line[1]:
					g['TN'].append(line[0]+'~'+'degenerate')
				else:
					g['TN'].append(line[0]+'~'+'normal')
			elif line[2] == 'UNDETERMINED':
				line[-1] = line[-1].replace('P', 'N')
				if 'NL' in line[-1] and 'T' not in line[-1] and 'C' not in line[-1]:
					c['NL'] += 1
					if 'degenerate' in line[1]:
						g['NL'].append(line[0]+'~'+'degenerate')
					else:
						g['NL'].append(line[0]+'~'+'normal')
				elif 'N' in line[-1] and 'L' not in line[-1] and 'T' not in line[-1] and 'C' not in line[-1]:
					c['NBS'] += 1
					if 'degenerate' in line[1]:
						g['NBS'].append(line[0]+'~'+'degenerate')
					else:
						g['NBS'].append(line[0]+'~'+'normal')
				elif 'TN' in line[-1] and 'L' not in line[-1]:
					c['TN'] += 1
					if 'degenerate' in line[1]:
						g['TN'].append(line[0]+'~'+'degenerate')
					else:
						g['TN'].append(line[0]+'~'+'normal')
				elif 'TNL' in line[-1]:
					c['TNL'] += 1
					if 'degenerate' in line[1]:
						g['TNL'].append(line[0]+'~'+'degenerate')
					else:
						g['TNL'].append(line[0]+'~'+'normal')
				elif 'CN' in line[-1] and 'L' not in line[-1]:
					c['CN'] += 1
					if 'degenerate' in line[1]:
						g['CN'].append(line[0]+'~'+'degenerate')
					else:
						g['CN'].append(line[0]+'~'+'normal')
				elif 'CNL' in line[-1]:
					c['CNL'] += 1
					if 'degenerate' in line[1]:
						g['CNL'].append(line[0]+'~'+'degenerate')
					else:
						g['CNL'].append(line[0]+'~'+'normal')
		elif line[1] == 'TX':
			c['TX'] += 1
			if 'degenerate' in line[1]:
				g['TX'].append(line[0]+'~'+'degenerate')
			else:
				g['TX'].append(line[0]+'~'+'normal')
		elif line[1] == 'CCX':
			c['CCX'] += 1
			if 'degenerate' in line[1]:
				g['CCX'].append(line[0]+'~'+'degenerate')
			else:
				g['CCX'].append(line[0]+'~'+'normal')

for k in l:
	if k in g:
		for j in g[k]:
			o2.write('%s\t%s\t%s\n' % (j.split('~')[0], j.split('~')[1], k))


