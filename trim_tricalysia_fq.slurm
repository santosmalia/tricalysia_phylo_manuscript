#!/bin/bash

#SBATCH --job-name hybpiper2_trim_tri_3dec24    # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=32	# 2 cores
#SBATCH --mem=40G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_hybpiper2_tri_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_hybpiper2_tri_%A.out		# name standard out files and include job ID (%A)

#make sure cpus match threds

# Try out trimming using adapters.fa from bbduk

#Load modules
module load gcc
module load arcc
module load openjdk
module load trimmomatic/0.39

#Set working directory
cd /cluster/medbow/project/tanklab/msantos2/rawreads_round1/tricalysia


ADAPTERS='/cluster/medbow/project/tanklab/msantos2/adapters.fa'
OUT_DIR='/cluster/medbow/project/tanklab/msantos2/trimmed_fq_tricalysia'



#script for trimmed reads
for f1 in *R1_001.fastq.gz
do
f2=${f1%%R1_001.fastq.gz}"R2_001.fastq.gz"
trimmomatic PE -threads 32 -summary summary_tri_trimmomatic_5dec24 $f1 $f2 $OUT_DIR/$f1""_R1_P.fq.gz $OUT_DIR/$f1""_R1_S.fq.gz $OUT_DIR/$f1""_R2_P.fq.gz $OUT_DIR/$f1""_R2_S.fq.gz ILLUMINACLIP:$ADAPTERS:2:30:10:8:true LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 MINLEN:36;
done
