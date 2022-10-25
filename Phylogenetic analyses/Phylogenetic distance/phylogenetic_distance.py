#!/public/agis/huangsanwen_group/lihongbo/software/miniconda3/bin/python3

import dendropy
import pandas as pd
import numpy as np
import sys

tree = dendropy.Tree.get(path=sys.argv[1], schema="newick", preserve_underscores=True)
pdm = tree.phylogenetic_distance_matrix()

labels = []
distances = []
for taxon1 in tree.taxon_namespace:
    labels.append(taxon1.label)
    each_rows = []
    for taxon2 in tree.taxon_namespace:
        weighted_patristic_distance = pdm.patristic_distance(taxon1, taxon2)
        each_rows.append(weighted_patristic_distance)
    distances.append(each_rows)

distances = pd.DataFrame(distances)
distances.index = labels
distances.columns = labels
print(distances.to_string())
#print("phylogenetic distance matrix")
#distances.head()
