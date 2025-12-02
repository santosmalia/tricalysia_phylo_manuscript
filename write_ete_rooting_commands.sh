#!/bin/bash

mkdir simulated_genetrees_rooted_mpest/
echo "from ete3 import Tree" > ete_commands.py
for i in {1..10000}; do echo "t = Tree(\"simulated_genetrees_astral/gtree$i.tre\")" >> ete_commands.py; echo "t.set_outgroup( t&\"galGal\" )" >> ete_commands.py; echo "t.write(format=9, outfile=\"simulated_genetrees_rooted_astral/gtree$i.tre\")" >> ete_commands.py; echo "print \"$i done\"" >> ete_commands.py; done
