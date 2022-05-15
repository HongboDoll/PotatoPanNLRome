#!/usr/bin/env python3

import sys

i1 = open(sys.argv[1]) ## input fasta
i2 = open(sys.argv[2], 'w') ## output

def read(fl_in):
    dic1 = {}
    ID = ''
    seq = ''
    for i in open(fl_in):
        if '>' in i:
            dic1[ID] = seq
            ID = i.strip()
            seq = ''
        else:
            seq += i.strip()
    dic1[ID] = seq
    dic1.pop('')
    return dic1


dic_fa = read(sys.argv[1])

out = i2

keys = list(dic_fa.keys())

length = len(dic_fa[keys[0]])

dic_fa_rm = {}
dic_tmp = {}
for i in keys:
	dic_fa_rm[i] = ''
	dic_tmp[i] = ''

count = 0
for idx in range(length):
	count += 1
	n = 0
	for ID in dic_fa:
		dic_tmp[ID] = dic_fa[ID][idx]
		if dic_fa[ID][idx] == '-':
			n += 1
	if n == 0:
		for ID in dic_tmp:
			dic_fa_rm[ID] += dic_tmp[ID]
	if count % 100000 == 0:
		print('Finished', count, 'sites')

for i in dic_fa_rm:
	out.write('{}\n{}\n'.format(i, dic_fa_rm[i]))

out.close()


