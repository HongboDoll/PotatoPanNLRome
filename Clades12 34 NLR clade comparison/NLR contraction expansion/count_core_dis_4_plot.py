#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1])  # pangenome_matrix_4_extract_core_dispensable_copy_number.xls
i2 = open(sys.argv[2])  # pangenome_matrix_t0_nr_t1_l0_e0_C75_S95__core_list.txt
i3 = open(sys.argv[3])  # pangenome_matrix_t0_nr_t1_l0_e0_C75_S95__soft-core_list.txt
i4 = open(sys.argv[4])  # pangenome_matrix_t0_nr_t1_l0_e0_C75_S95__shell_list.txt

core = {}
for line in i2:
	line = line.strip()
	core[line] = ''

softcore = {}
for line in i3:
	line = line.strip()
	softcore[line] = ''

shell = {}
for line in i4:
	line = line.strip()
	shell[line] = ''

order = {}
core_count = {}
softcore_count = {}
shell_count = {}
specific_count = {}
for line in i1:
	if 'Cluster' in line:
		line = line.strip().split()
		for k in line[1:]:
			core_count[k] = 0
			softcore_count[k] = 0
			shell_count[k] = 0
			specific_count[k] = 0
		for n in range(1, len(line)):
			order[n-1] = line[n]
		#print(core_count)
		#print(order)
	else:
		line = line.strip().split()
		if line[0] in core:
			for n in range(1, len(line)):
				if line[n] != '-':
					core_count[order[n-1]] += (line[n].count(',')+1)
		elif line[0] in softcore:
			for n in range(1, len(line)):
				if line[n] != '-':
					softcore_count[order[n-1]] += (line[n].count(',')+1)
		elif line[0] in shell:
			for n in range(1, len(line)):
				if line[n] != '-':
					shell_count[order[n-1]] += (line[n].count(',')+1)
		else:
			for n in range(1, len(line)):
				if line[n] != '-':
					specific_count[order[n-1]] += (line[n].count(',')+1)

print('Accessions',end='\t')
for i in range(0, len(order)):
	print(order[i], end='\t')
print('')
print('Core_genes', end='\t')
for i in range(0, len(order)):	
	print(core_count[order[i]], end='\t')
print('')	

print('Soft-core_genes', end='\t')
for i in range(0, len(order)):
	print(softcore_count[order[i]], end='\t')
print('')

print('Shell_genes', end='\t')
for i in range(0, len(order)):
	print(shell_count[order[i]], end='\t')
print('')

print('Specific_genes', end='\t')
for i in range(0, len(order)):
	print(specific_count[order[i]], end='\t')
print('')
		
		
		
		
		
		
