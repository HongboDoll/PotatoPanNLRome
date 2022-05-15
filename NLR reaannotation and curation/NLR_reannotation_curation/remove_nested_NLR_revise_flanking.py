#!/usr/bin/env python3

import sys,math

i1 = sys.stdin  # grep -v '#' Heinz.NLR.gff3 | sort -k1,1 -k4,4n -k5,5n |
i2 = int(sys.argv[1])  # left/right flanking length, 2000

chr_name = {}
chr_name_revise = {}
chr_name_flanking = {}
for line in i1:
	line = line.strip().split()
	chr_name_flanking[line[0]] = []
	if line[0] not in chr_name:
		chr_name[line[0]] = []
		chr_name_revise[line[0]] = []
		chr_name[line[0]].append([int(line[3]), int(line[4]), line[6], line[-1]])
		chr_name_revise[line[0]].append([int(line[3]), int(line[4]), line[6], line[-1]])
	else:
		chr_name[line[0]].append([int(line[3]), int(line[4]), line[6], line[-1]])
		chr_name_revise[line[0]].append([int(line[3]), int(line[4]), line[6], line[-1]])

for k in chr_name:
	if len(chr_name[k]) <= 1:
		pass
	else:
		pos_pop = []
		for n in range(0, len(chr_name[k])-1):
			left1 = chr_name[k][n][0]
			right1 = chr_name[k][n][1]
			orient1 = chr_name[k][n][2]
			left2 = chr_name[k][n+1][0]
			right2 = chr_name[k][n+1][1]
			orient2 = chr_name[k][n+1][2]
			if orient1 == orient2 and (left2 >= left1 and left2 <= right1 and right2 > right1):
				pos_pop.append(n)
			elif orient1 == orient2 and (left2 > left1 and left2 <= right1 and right2 <= right1):
				pos_pop.append(n+1)
			chr_name_revise[k] = [i for num,i in enumerate(chr_name[k]) if num not in pos_pop]			

#print(chr_name_revise)
for k in chr_name_revise:
	if len(chr_name_revise[k]) <= 1:
		if chr_name_revise[k][0][0] > 2000:
			chr_name_flanking[k] = [[chr_name_revise[k][0][0]-2000, chr_name_revise[k][0][1]+2000, chr_name_revise[k][0][2], chr_name_revise[k][0][3]]]
		else:
			chr_name_flanking[k] = [[chr_name_revise[k][0][0], chr_name_revise[k][0][1]+2000, chr_name_revise[k][0][2], chr_name_revise[k][0][3]]]
	else:
		for n in range(0, len(chr_name_revise[k])):
			left1 = chr_name_revise[k][n][0]
			right1 = chr_name_revise[k][n][1]
			orient1 = chr_name_revise[k][n][2]
			if n == 0:
				left2 = chr_name_revise[k][n+1][0]
				right2 = chr_name_revise[k][n+1][1]
				orient2 = chr_name_revise[k][n+1][2]
				if left2 - right1 <= 4000 and orient1 == orient2:
					flank = int(math.floor((left2 - right1)/2))
					if chr_name_revise[k][n][0] > 2000:
						chr_name_flanking[k].append([chr_name_revise[k][n][0]-2000, chr_name_revise[k][n][1]+flank, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
					else:
						chr_name_flanking[k].append([chr_name_revise[k][n][0], chr_name_revise[k][n][1]+flank, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
				else:
					if chr_name_revise[k][n][0] > 2000:
						chr_name_flanking[k].append([chr_name_revise[k][n][0]-2000, chr_name_revise[k][n][1]+2000, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
					else:
						chr_name_flanking[k].append([chr_name_revise[k][n][0], chr_name_revise[k][n][1]+2000, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
			elif n != 0 and n != len(chr_name_revise[k])-1:
				left2 = chr_name_revise[k][n+1][0]
				right2 = chr_name_revise[k][n+1][1]
				orient2 = chr_name_revise[k][n+1][2]
				left0 = chr_name_revise[k][n-1][0]
				right0 = chr_name_revise[k][n-1][1]
				orient0 = chr_name_revise[k][n-1][2]
				if orient0 == orient1 and orient1 == orient2:
					if left1 - right0 > 4000:
						flank_left = 2000
					elif left1 - right0 <= 4000:
						flank_left = int(math.floor((left1 - right0)/2))
					if left2 - right1 > 4000:
						flank_right = 2000
					elif left2 - right1 <= 4000:
						flank_right = int(math.floor((left2 - right1)/2))
					chr_name_flanking[k].append([chr_name_revise[k][n][0]-flank_left, chr_name_revise[k][n][1]+flank_right, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
				elif orient0 != orient1 and orient1 == orient2:
					flank_left = 2000
					if left2 - right1 > 4000:
						flank_right = 2000
					elif left2 - right1 <= 4000:
						flank_right = int(math.floor((left2 - right1)/2))
					chr_name_flanking[k].append([chr_name_revise[k][n][0]-flank_left, chr_name_revise[k][n][1]+flank_right, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
				elif orient0 == orient1 and orient1 != orient2:
					if left1 - right0 > 4000:
						flank_left = 2000
					elif left1 - right0 <= 4000:
						flank_left = int(math.floor((left1 - right0)/2))
					flank_right = 2000
					chr_name_flanking[k].append([chr_name_revise[k][n][0]-flank_left, chr_name_revise[k][n][1]+flank_right, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
				elif orient0 != orient1 and orient1 != orient2:
					flank_left = 2000
					flank_right = 2000
					chr_name_flanking[k].append([chr_name_revise[k][n][0]-flank_left, chr_name_revise[k][n][1]+flank_right, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
					
			elif n == len(chr_name_revise[k])-1:
				left0 = chr_name_revise[k][n-1][0]
				right0 = chr_name_revise[k][n-1][1]
				orient0 = chr_name_revise[k][n-1][2]
				if orient0 == orient1:
					if left1 - right0 > 4000:
						flank_left = 2000
					elif left1 - right0 <= 4000:
						flank_left = int(math.floor((left1 - right0)/2))
					flank_right = 2000
					chr_name_flanking[k].append([chr_name_revise[k][n][0]-flank_left, chr_name_revise[k][n][1]+flank_right, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])
				elif orient0 != orient1:
					flank_left = 2000
					flank_right = 2000
					chr_name_flanking[k].append([chr_name_revise[k][n][0]-flank_left, chr_name_revise[k][n][1]+flank_right, chr_name_revise[k][n][2], chr_name_revise[k][n][3]])


for k in chr_name_flanking:
	for n in chr_name_flanking[k]:
		print(k, 'NLR_Annotator\tNBSLRR', n[0], n[1], '.', n[2], '.', n[3], sep='\t')
