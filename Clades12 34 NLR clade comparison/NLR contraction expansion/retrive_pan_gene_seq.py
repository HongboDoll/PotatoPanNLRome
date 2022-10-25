#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # all_12_cuc.fna
i2 = open(sys.argv[2])  # pangenome_matrix_4_extract_core_dispensable_genes.xls

def read_fasta_len(fasta):
	scaf = {}	 # to calculate the length of each scaffold
	name = ''
	seq= ''
	a=0
	for line in fasta:
		line=line.strip()
		if '>' in line:
			scaf[name] = len(seq)
			seq = ''
			name = line.split()[0][1:]
			a = 1
			continue
		elif a and '>' not in line:
			seq += line
	scaf[name] = len(seq)
	scaf.pop('')
	return scaf

def read_fasta(fasta):
	scaf = {}	 # to calculate the length of each scaffold
	name = ''
	seq= ''
	a=0
	for line in fasta:
		line=line.strip()
		if '>' in line:
			scaf[name] = seq
			seq = ''
			name = line.split()[0][1:]
			a = 1
			continue
		elif a and '>' not in line:
			seq += line
	scaf[name] = seq
	scaf.pop('')
	return scaf


dl = read_fasta_len(i1)
i1.seek(0)
d  = read_fasta(i1)

#l = []
#
#for line in i2:
#	if 'Cluster' in line:
#		line = line.strip().split()
#		for k in line[1:]:
#			l.append(k.split('_')[1])
#i2.seek(0)
for line in i2:
	if 'Cluster' not in line:
		line = line.strip().split()
		if line[-5] != '-' and line[-5] != "UA":
			print('>'+line[0], line[-5].split(',')[0],  sep=' ')
			print(d[line[-5].split(',')[0]])
		else:
			dll = {}
			for i in line[1:-5] + line[-4:]:
				for j in i.split(','):
					if j and j != '-':
						dll[j] = dl[j]
			dll_sort = sorted(dll.items(),key=lambda x:x[1],reverse=True) 
			k = dll_sort[0][0]
			#acc_name = k.split('_')[1].replace('Csa', '')
			#acc_fna = ''
			#for item in l:
			#	if acc_name in item:
			#		acc_fna = item.replace('.nucl', '')
			print('>'+line[0], k, sep=' ')
			print(d[k])
			
			
			
			
			
			
			
			
