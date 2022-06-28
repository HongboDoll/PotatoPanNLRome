#!/usr/bin/env python3

import sys,itertools

item = open(sys.argv[1])
time = int(sys.argv[2])  ## combinations time

b = []
for line in item:
	k = line.strip().split(',')
	for j in k:
		b.append(j)

b = set(b)
c = itertools.combinations(b,time)
for i in list(c):
	for k in i:
		if i.index(k) != len(i)-1:
			print(k,end=' ')
		else:
			print(k)
