import sys
import os
if len(sys.argv) != 4:
	print('\n\tpython3 *.py xxx.flt.inner_genes.gff xxx.NBS.pos.bed xxx.paired_NBS.txt\n')
	sys.exit()

os.system('sort -k1,1 -k4,4n {} > tmp'.format(sys.argv[1]))
ls_genes = []
dic_direction = {}
dic_chr = {}
for i in open('tmp'):
	ii = i.strip().split('\t')
	if ii[2] == 'mRNA':
		ID = ii[8].split(';')[0].split('=')[1]
		ls_genes.append(ID)
		dic_direction[ID] = ii[6]
		dic_chr[ID] = [ii[0], ii[3], ii[4]]

dic_nb = {}
for i in open(sys.argv[2]):
	ii = i.strip().split('\t')
	dic_nb[ii[3]] = ii[4]

out = open(sys.argv[3],'w')
out.write('#CHRO\tSTART\tEND\t\tID\tDIREC\tNLR_type\tCHRO\tSTART\tEND\t\tID\tDIREC\tNLR_type\tDistance\n')
for i in range(len(ls_genes) -1):
	ID1 = ls_genes[i]
	ID2 = ls_genes[i + 1]
	if dic_chr[ID1][0] == dic_chr[ID2][0]:
		if ID1 in dic_nb and ID2 in dic_nb:
			if dic_direction[ID1] == '-' and dic_direction[ID2] == '+':
				dist = int(dic_chr[ID2][1]) - int(dic_chr[ID1][2])
				out.write('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\n'.format('\t'.join(dic_chr[ID1]), ID1, dic_direction[ID1],dic_nb[ID1], '\t'.join(dic_chr[ID2]), ID2, dic_direction[ID2], dic_nb[ID2], dist))
os.system('rm tmp')
