#!/bin/bash

for i in C400 C509 C672 C555  C871 C534  C850
do
    cd $i
    sbatch -J ${i}PurgedNLR -p queue1 --qos=queue1 -N 1 --ntasks-per-node=52 -e %x.err -o %x.out "./maker.sh"
    cd -
done

