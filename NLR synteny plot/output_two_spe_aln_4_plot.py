#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # Solanum_jamesii.card1.bed
i2 = open(sys.argv[2])  # Solanum_cardiophyllumC509.card1.bed
spe1 = sys.argv[3]  # Solanum_jamesii
spe2 = sys.argv[4]  # Solanum_cardiophyllumC509
i3 = open(sys.argv[5])  # Solanum_jamesii_Solanum_cardiophyllumC509.one2one
order = int(sys.argv[6]) # 2
 
g1 = {}
g1_start = []
g1_end = []
for line in i1:
	line = line.strip().split()
	g1[line[0]] = [int(line[2]), int(line[3]), line[-3]]
	g1_start.append(int(line[2]))
	g1_end.append(int(line[3]))

g2 = {}
g2_start = []
g2_end = []
for line in i2:
	line = line.strip().split()
	g2[line[0]] = [int(line[2]), int(line[3]), line[-3]]
	g2_start.append(int(line[2]))
	g2_end.append(int(line[3]))

g1_range = [min(g1_start), max(g1_end)]
g2_range = [min(g2_start), max(g2_end)]

correspondance = {}
for line in i3:
	line = line.strip().split()
	if line[0] not in correspondance:
		correspondance[line[0]] = [line[1]]
	else:
		correspondance[line[0]].append(line[1])

for k in g1:
	if k in correspondance:
		if len(correspondance[k]) == 1:
			if correspondance[k][0] in g2:
				if g1[k][2] == g2[correspondance[k][0]][2]:
					print(spe1, g1[k][2], g1[k][0], g1[k][1], spe2, g2[correspondance[k][0]][2], g2[correspondance[k][0]][0], g2[correspondance[k][0]][1], order, sep='\t')
				else:
					print(spe1, "+", g1[k][0], g1[k][1], spe2, "+", g2[correspondance[k][0]][0], g2[correspondance[k][0]][1], order, sep='\t')
		else:
			for j in correspondance[k]:
				if j in g2:
					if g1[k][2] == g2[j][2]:
						print(spe1, g1[k][2], g1[k][0], g1[k][1], spe2, g2[j][2], g2[j][0], g2[j][1], order, sep='\t')		
					else:
						print(spe1, '+', g1[k][0], g1[k][1], spe2, '+', g2[j][0], g2[j][1], order, sep='\t')




