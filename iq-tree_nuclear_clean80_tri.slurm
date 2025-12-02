#!/bin/bash

#SBATCH --job-name iq-tree_nuclear_clean80_tri  # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=32	# 2 cores
#SBATCH --mem=30G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_iq-tree_nuclear_phyu80_tri_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_iq-tree_nuclear_phyu80_tri_%A.out		# name standard out files and include job ID (%A)

module load gcc
module load arcc
module load python
module load mafft
module load openjdk
module load iq-tree

cd /cluster/medbow/project/tanklab/msantos2/iqtree_results

#final gene tree for each algorithm - IQTree
iqtree2 -S /cluster/medbow/project/tanklab/msantos2/trimmed_fq_tricalysia/bwa_cov8/supercontig/alignments/cleaned80 -m MFP -T auto --prefix Tricalysia_nuclear_genetrees_clean80_sc_1feb2025 -B 1000 -alrt 1000

#partitioned tree
iqtree2 -p  /cluster/medbow/project/tanklab/msantos2/trimmed_fq_tricalysia/bwa_cov8/supercontig/alignments/cleaned80 -m TESTMERGE -T auto --prefix Tricalysia_nuclear_concattree_clean80_sc_1feb2025 -B 1000 -alrt 1000
