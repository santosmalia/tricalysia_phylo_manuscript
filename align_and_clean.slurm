#!/bin/bash

#SBATCH --job-name align_clean   # give the job a name
#SBATCH -A tanklab    # specify the account
#SBATCH -t 0-24:00		 # how much time?
#SBATCH --nodes=1			# how many nodes?
#SBATCH --cpus-per-task=32	# 2 cores
#SBATCH --mem=30G			# 50 GB memory
#SBATCH --mail-type=ALL		# Send emails on start, fail, completion
#SBATCH --mail-user=msantos2@uwyo.edu   # specify your email
#SBATCH -e err_align_clean_tri_%A.err		# name error files and include job ID (%A)
#SBATCH -o std_align_clean_%A.out		# name standard out files and include job ID (%A)

module load gcc/12.2.0
module load arcc/1.0
module load python/3.10.6 
module load mafft

# change directory to supercontigs

cd supercontig

mkdir alignments

for i in *.fasta
do mafft --auto --thread 16 --preservecase $i > $i.aln
done

mv *.aln alignments

cd alignments

clean alignment (80% cutoff)
for i in *.aln
do java -jar /cluster/medbow/project/tanklab/msantos2/phyutility/phyutility.jar -clean 0.8 -in $i -out $i"_cleaned80.aln"
done

mkdir cleaned
mv *_cleaned80.aln cleaned

mkdir lessthan3

# Loop through all FASTA files in the current directory
for file in *.aln; do
   Count the number of lines starting with '>'
  count=$(grep -c '^>' "$file")

   If the count is less than 3, move the file to the lessthan3 directory
  if [ "$count" -lt 3 ]; then
    mv "$file" lessthan3/
  fi
done