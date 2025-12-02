#!/bin/bash

#SBATCH --job-name coalescent_simulations_13Feb25  # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=1	# 2 cores
#SBATCH --mem=30G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_coalescent_simulations_13Feb25_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_coalescent_simulations_13Feb25_%A.out		# name standard out files and include job ID (%A)

module load gcc
module load arcc
module load python
module load r
module load perl
module load openjdk


#An ultrametric species tree with branch lengths in mutational units (⁠uT) was estimated 
#by constraining an ML tree search of the concatenated alignment to the 
#ASTRAL species tree topology with a GTR  GAMMA model while enforcing a strict molecular 
#clock in IQtree2
# Put branch lengths on ASTRAL collapsed_50 topology using IQ-tree and fixed topology

#python3 /cluster/medbow/project/tanklab/msantos2/AMAS/amas/AMAS.py concat -f fasta -d dna -i *.fasta -u nexus --part-format nexus

#STEP 1: generate simulated genetrees (run in directory 'simulated_genetrees_astral/')
cd /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/simulated_genetrees_astral

Rscript /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/scripts/coal_sim.r

# STEP 2: root simulated genetrees with phyutility

for i in *.tre
do java -jar /cluster/medbow/project/tanklab/msantos2/phyutility/phyutility.jar -rr -names Bertiera_bicarpellata_ERR5033627_PAFTOL_006566 -in $i -out $i"_rooted.tre"
done 

mkdir simulated_genetrees_rooted_astral
mv *_rooted.tre simulated_genetrees_rooted_astral

cd simulated_genetrees_rooted_astral

# STEP 3: create input file for TreeCmp

# concatenate all trees into one tree file 
for i in {1..10000}; 
do cat gtree$i.tre_rooted.tre >> /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/output/simulated_astral_treecmp_input.tre; echo $i done; done
#add newlines to output tree file
perl -pi -e 's/;/;\n/g' /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/output/simulated_astral_treecmp_input.tre


#STEP 4: calculate Robinson-Foulds cluster and matching cluster distance of each simulated genetree
#to the MP-EST/ASTRAL species tree topology with TreeCmp.  The reference species tree (topology only)
#is provided in this scripts directory as species_tree.tre

cd ../../output

#TreeCmp for simulated vs ASTRAL tree
java -jar /cluster/medbow/project/tanklab/msantos2/TreeCmp_v2.0-b76/bin/treeCmp.jar -i simulated_astral_treecmp_input.tre \
-r /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/output/ultrametric_mutational_length_ASTRAL_topology_rooted.tre -d mc rc -o simulated_astral_treecmp_output.txt -N -I -P


java -jar /cluster/medbow/project/tanklab/msantos2/phyutility/phyutility.jar -rr -names Bertiera_bicarpellata_ERR5033627_PAFTOL_006566 -in /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/Tricalysia_nuclear_genetrees_clean30_s30g30_no19386_nocongesta_UFB_11Mar2025.tre -out /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/Tricalysia_nuclear_genetrees_clean30_s30g30_no19386_nocongesta_UFB_11Mar2025_rooted.tre

#TreeCmp for empirical vs ASTRAL tree
java -jar /cluster/medbow/project/tanklab/msantos2/TreeCmp_v2.0-b76/bin/treeCmp.jar -i /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/Tricalysia_nuclear_genetrees_clean30_s30g30_no19386_nocongesta_UFB_11Mar2025_rooted.tre \
-r /cluster/medbow/project/tanklab/msantos2/coalescent_simulations/output/ultrametric_mutational_length_ASTRAL_topology_rooted.tre -d mc rc -o empirical_astral_treecmp_output.txt -N -I -P

# The ratio of mean gene tree–species tree distances for simulated gene trees relative to 
# mean distances for empirically
# estimated gene trees was calculated as a measure of the
# amount of observed gene tree heterogeneity that can
# be accounted for by coalescent processes.

#Note that you should provide the full path to the local install of TreeCmp on your system.
#This command will output the file 'simulated_astral_treecmp_output.txt', with genetree-species tree
#distances for each simulated genetree, followed by a summary section at the end of the file. 



