#!/bin/bash

#SBATCH --job-name hybpiper23_tricalysia_cov5_30Sep24   # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=32	# 2 cores
#SBATCH --mem=30G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_hybpiper23_cov5_tri_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_hybpiper23_cov5_tri_%A.out		# name standard out files and include job ID (%A)
#SBATCH --array=1-133

module load gcc/12.2.0
module load arcc/1.0
module load python/3.10.6 
module load miniconda3
conda activate hybpiper2.3

cd /project/tanklab/msantos2/trimmedReads_all/cov5

mkdir bwa_cov5

cd bwa_cov5

SAMPLE_FILE="/pfs/tc1/project/tanklab/msantos2/trimmedReads_all/namelist_all_tricalysia.txt"

name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_FILE")



#assemble command
while read name;
do hybpiper assemble -r /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/"$name"_R1_P.fq /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/"$name"_R2_P.fq --unpaired /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/"$name"_12_S.fq --prefix $name -t_dna /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/rubiaceae_targetfile.fasta --bwa --cov_cutoff 5 --merged --force_overwrite
done < /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/namelist_all_tricalysia.txt

#Post assembly

hybpiper stats -t_dna /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/tricalysia_targetfile_fixed.fasta gene /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/namelist_wo_combines.txt

hybpiper recovery_heatmap seq_lengths.tsv

hybpiper retrieve_sequences -t_dna /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/tricalysia_targetfile_fixed.fasta dna --sample_names /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/namelist_wo_combines.txt

#There are two filters, --length_filter for the minimum length to accept a sequence (for all genes) and --percent_filter for a fraction of the mean length determined from the seq_lengths.tsv file for each gene. For example:

hybpiper filter_by_length dna --seq_lengths_file seq_lengths.tsv --length_filter 90 --percent_filter 0.80


#Paralogs
hybpiper paralog_retriever /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/namelist_all_tricalysia.txt -t_dna /pfs/tc1/project/tanklab/msantos2/trimmedReads_all/supercontigs/rubiaceae_tricalysia_targetfile.fasta 

