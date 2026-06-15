#!/bin/bash

#SBATCH --job-name ASTRAL_tricalysia_13Feb25  # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=1	# 2 cores
#SBATCH --mem=30G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_ASTRAL_tricalysia_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_ASTRAL_tricalysia_13Feb25_%A.out		# name standard out files and include job ID (%A)

module load gcc
module load arcc
module load python
module load astral
module load miniconda3

conda activate newick_utilities

cd /cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/filtered_paragone100/astral_results_4Apr25

nw_ed  /cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/filtered_paragone100/iqtree_results_3Apr25/sample_30_gene_30_castilleja_nuc_genetree.tre 'i & b<=10' o > sample_30_gene_30_castilleja_nuc_genetree_BS10.tre

astral -i sample_30_gene_30_castilleja_nuc_genetree_BS10.tre -o sample_30_gene_30_castilleja_nuc_genetree_BS10_ASTRAL.tre

#Full annotations
astral -q sample_30_gene_30_castilleja_nuc_genetree_BS10.tre -i /cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/filtered_paragone100/iqtree_results_3Apr25/sample_30_gene_30_castilleja_nuc_genetree.tre -t 2 -o sample_30_gene_30_castilleja_nuc_genetree_BS10_ASTRAL-t2.tre

# polytomy test
astral -q sample_30_gene_30_castilleja_nuc_genetree_BS10.tre -i /cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/filtered_paragone100/iqtree_results_3Apr25/sample_30_gene_30_castilleja_nuc_genetree.tre  -t 10 -o sample_30_gene_30_castilleja_nuc_genetree_BS10_ASTRAL-t10.tre