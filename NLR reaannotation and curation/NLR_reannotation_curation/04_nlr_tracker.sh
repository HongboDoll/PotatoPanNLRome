#!/bin/bash

### NLR proteins
for i in C400 C509 C555 C534 C672 C850 C871
do
	sed -i 's/\*//g' pep/${i}*pep.fa
	NLRtracker.sh -s pep/${i}*pep.fa -t p -c 52 -o ${i}
done

### whole genome proteins used for RNL extraction
for i in Solanum_cardiophyllumC509 Solanum_dolichocremastrumC850 Solanum_cajamarquenseC534 Solanum_hintoniiC871 Solanum_commersoniiC672 Solanum_chacoenseC555 Solanum_candolleanumC400
do
rm -rf ${i}
echo -e """#!/bin/bash
	sed -i 's/\*//g' pep/${i}*pep.fa
	NLRtracker.sh -s pep/${i}*pep.fa -t p -c 52 -o ${i}
""" > ${i}.run.sh
done

chmod 755 *run.sh


for i in Solanum_cardiophyllumC509 Solanum_dolichocremastrumC850 Solanum_cajamarquenseC534 Solanum_hintoniiC871 Solanum_commersoniiC672 Solanum_chacoenseC555 Solanum_candolleanumC400
do
	sbatch -J ${i} -p queue1 --qos=queue1 -N 1 --ntasks-per-node=52 -e %x.err -o %x.out "./${i}.run.sh"
done
