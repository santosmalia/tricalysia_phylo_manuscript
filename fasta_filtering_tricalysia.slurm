#!/bin/bash

#SBATCH --job-name filter_castilleja_apr25   # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=1	# 2 cores
#SBATCH --mem=30G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_filter_castilleja_apr25_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_filter_castilleja_apr25_%A.out		# name standard out files and include job ID (%A)


module load gcc
module load arcc
module load python

pip install biopython

python /cluster/medbow/project/tanklab/msantos2/python_scripts/fasta_filtering_script.py
