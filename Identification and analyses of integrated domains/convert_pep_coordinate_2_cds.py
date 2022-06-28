#!/usr/bin/env python3

import sys

i1 = sys.stdin  # 

for line in i1:
	line = line.strip().split(':')
	start = int(line[1].split('-')[0])
	end = int(line[1].split('-')[1])
	cds_start = str((3 * (start -1)) + 1)
	cds_end = str(3 * end)
	print(line[0]+':'+cds_start+'-'+cds_end)


