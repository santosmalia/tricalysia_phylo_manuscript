#!/bin/bash
#SBATCH --job-name=iqtree_parallel
#SBATCH -A tanklab
#SBATCH -t 0-24:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=msantos2@uwyo.edu
#SBATCH -e err_iqtree_parallel_%A.err
#SBATCH -o std_iqtree_parallel_%A.out

# Base directory containing the filtered FASTA folders
BASE_DIR="/cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/filtered_paragone100"

# Output directory for IQ-Tree results
OUTPUT_DIR="/cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/filtered_paragone100/iqtree_results_3Apr25"

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Function to submit a job for a single folder
submit_job() {
    local folder=$1
    local folder_name=$(basename $folder)

    # Create a temporary SLURM script for this job
    TEMP_SCRIPT="${OUTPUT_DIR}/temp_script_${folder_name}.sh"
    cat <<EOF > $TEMP_SCRIPT
#!/bin/bash
#SBATCH --job-name=iqtree_$folder_name
#SBATCH -A tanklab
#SBATCH -t 0-24:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=msantos2@uwyo.edu
#SBATCH -e $OUTPUT_DIR/err_iqtree_${folder_name}_%j.err
#SBATCH -o $OUTPUT_DIR/std_iqtree_${folder_name}_%j.out

# Load required modules
module load gcc
module load arcc
module load iq-tree

# Run gene tree analysis
iqtree2 -S $folder -m MFP -T auto --prefix $OUTPUT_DIR/${folder_name}_castilleja_nuc_genetree -B 1000 -alrt 1000

# Run partitioned tree analysis
iqtree2 -p $folder -m TESTMERGE -T auto --prefix $OUTPUT_DIR/${folder_name}_castilleja_nuc_concattree -B 1000 -alrt 1000
EOF

    # Submit the job
    sbatch $TEMP_SCRIPT

    # Clean up the temporary script
    rm $TEMP_SCRIPT
}

# Iterate through all folders and submit jobs
for folder in $BASE_DIR/*; do
    if [ -d "$folder" ]; then
        submit_job $folder
    fi
done

echo "All jobs submitted."