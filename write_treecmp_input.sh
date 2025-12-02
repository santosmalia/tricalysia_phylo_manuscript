#!/bin/bash

for i in {1..10000}; do cat simulated_genetrees_rooted_mpest/gtree$i.tre >> simulated_mpest_treecmp_input.tre; echo $i done; done
#add newlines to output tree file
perl -pi -e 's/;/;\n/g' simulated_mpest_treecmp_input.tre
