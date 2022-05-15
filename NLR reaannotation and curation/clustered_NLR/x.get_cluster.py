import sys
if len(sys.argv) != 3:
	print('\n\tpython3 *.py xxx.canonical.bed cluster.xxx.txt\n')
	sys.exit()
out = open(sys.argv[2],'w')
bed = open(sys.argv[1])

l1 = bed.readline().strip().split()
chro = l1[0]
p1 = int(l1[1])
p2 = int(l1[2])
ID = l1[3]
ls_pos = [p1, p2]
ls_id = [ID]
for i in bed:
	ii = i.strip().split()
	if ii[0] != chro:
		if len(ls_pos) > 2:
			out.write('{}\t{}\t{}\t{}\t{}\n'.format(chro, ls_pos[0], ls_pos[-1],len(ls_id), ','.join(ls_id)))
		ls_pos = [ii[1], ii[2]]
		ls_id = [ii[3]]
		chro = ii[0]
		p2 = int(ii[2])
	elif int(ii[1]) - p2 <= 200000:
		ls_pos.append(ii[2])
		ls_id.append(ii[3])
		p2 = int(ii[2])
	else:
		if len(ls_pos) > 2:
			out.write('{}\t{}\t{}\t{}\t{}\n'.format(chro, ls_pos[0], ls_pos[-1], len(ls_id), ','.join(ls_id)))
		ls_pos = [ii[1], ii[2]]
		ls_id = [ii[3]]
		p2 = int(ii[2])
if len(ls_pos) > 2:
	out.write('{}\t{}\t{}\t{}\t{}\n'.format(chro, ls_pos[0], ls_pos[-1], len(ls_id), ','.join(ls_id)))

