import sys
import os
if len(sys.argv) != 4:
	print('\n\tpython3 *.py xxx.integrated.gff xxx.cluster.txt xxx.cluster.flt.txt\n')
	sys.exit()

def read_gff(fl):
	os.system('sort -k1,1 -k4n,4 {} > tmp'.format(fl))
	dic1 = {}
	ls = []
	for i in open('tmp'):
		ii = i.strip().split('\t')
		if ii[2] == 'mRNA':
			ID = ii[8].split(';')[0].split('=')[1]
			dic1[ID] = [ii[0], ii[3], ii[4]]
			ls.append(ID)
	os.system('rm tmp')
	return dic1, ls

def flt(dic1, ls, fl_in, fl_out):
	out = open(fl_out, 'w')
	for i in open(fl_in):
		ii = i.strip().split('\t')
		clus = ii[-1].split(',')
		n = 0
		ls_clus = []
		for i in range(len(clus) -1):
			indx1 = ls.index(clus[i])
			indx2 = ls.index(clus[i + 1])
			if abs(indx2 - indx1) <= 8:
				n += 1
				if clus[i] not in ls_clus:
					ls_clus.append(clus[i])
				if clus[i + 1] not in ls_clus:
					ls_clus.append(clus[i + 1])
			elif n > 0:
				chro = dic1[ls_clus[0]][0]
				p1 = dic1[ls_clus[0]][1]
				p2 = dic1[ls_clus[-1]][2]
				out.write('{}\t{}\t{}\t{}\t{}\n'.format(chro, p1, p2, len(ls_clus), ','.join(ls_clus)))
				ls_clus = []
				n = 0
		if n > 0:
			chro = dic1[ls_clus[0]][0]
			p1 = dic1[ls_clus[0]][1]
			p2 = dic1[ls_clus[-1]][2]
			out.write('{}\t{}\t{}\t{}\t{}\n'.format(chro, p1, p2, len(ls_clus), '\t'.join(ls_clus)))

#dic_gff, ls_gff = read_gff('../../../00-gff_for_RGA/DM.fmt.gff')
#flt(dic_gff, ls_gff, '../01-cluster/DM.cluster.txt', 'DM.cluster.flt.txt')

dic_gff, ls_gff = read_gff(sys.argv[1])
flt(dic_gff, ls_gff, sys.argv[2], sys.argv[3])
			
			

