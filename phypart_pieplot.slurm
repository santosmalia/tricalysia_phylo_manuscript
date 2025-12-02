#!/bin/bash

#SBATCH --job-name phyparts  # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=1	# 2 cores
#SBATCH --mem=50G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_phyparts_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_phyparts_%A.out	

# Load necessary modules
module load arcc
module load gcc
module load openjdk
module load python
module load miniconda3

conda activate ete3_env

# Before you run phyparts you need a directory of rooted tree with no support values. 
# run split_tree_file.py

cd /cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/phyparts


# from ete3 import Tree
# 
# # Load the tree
# t = Tree("sample50_gene_50_castilleja_nuc_genetree-mr.tre")
# 
# # Assign unique integer names to internal nodes
# i = 1
# for node in t.traverse("postorder"):
#     if not node.is_leaf():
#         node.name = str(i)
#         i += 1
# 
# # Save the re-labeled tree
# t.write(outfile="s50g50_cleaned_genetree_relabelled.tre", format=1)
# 
# 
java -jar /cluster/medbow/project/tanklab/software/phyparts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d split_tree -m sample_50_gene_50_castilleja_nuc_concattree-rr-nosupport.tre -o out2


python phypartspiecharts.py sample_50_gene_50_castilleja_nuc_concattree-rr-nosupport.tre out2 191
