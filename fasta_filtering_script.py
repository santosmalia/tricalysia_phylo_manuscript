import os
from Bio import SeqIO
from collections import defaultdict

def parse_fasta_files(directory):
    """Parse all FASTA files in the given directory."""
    sequences = defaultdict(dict)  # sequences[gene][sample] = sequence
    samples = set()  # Set to store unique sample IDs
    genes = set()    # Set to store unique gene names

    print(f"Input directory: {directory}")
    print(f"Files in input directory: {os.listdir(directory)}")

    for filename in os.listdir(directory):
        if filename.endswith((".fasta", ".fa", ".aln")):  # Process .fasta, .fa, and .aln files
            filepath = os.path.join(directory, filename)
            gene = filename.split(".")[0]  # Gene name is derived from the filename
            genes.add(gene)
            print(f"Processing {filename} (gene: {gene})...")

            try:
                for record in SeqIO.parse(filepath, "fasta"):
                    sample = record.id  # Sample ID is derived from the sequence header
                    samples.add(sample)
                    sequences[gene][sample] = str(record.seq)  # Store sequence by gene and sample
                    print(f"  Added sample {sample} for gene {gene}")
            except Exception as e:
                print(f"Error processing {filename}: {e}")

    print(f"Total samples: {len(samples)}")
    print(f"Total genes: {len(genes)}")
    return sequences, samples, genes

def filter_samples(sequences, samples, genes, sample_threshold):
    """Filter out samples that have less than the specified percentage of genes."""
    filtered_samples = set()
    total_genes = len(genes)

    for sample in samples:
        num_genes = sum(1 for gene in genes if sample in sequences[gene])
        if (num_genes / total_genes) >= (sample_threshold / 100):
            filtered_samples.add(sample)
            print(f"Sample {sample} passed filter with {num_genes}/{total_genes} genes")

    print(f"Samples after filtering: {len(filtered_samples)}")
    return filtered_samples

def filter_genes(sequences, samples, genes, gene_threshold):
    """Filter out genes that are present in less than the specified percentage of samples."""
    filtered_genes = set()
    total_samples = len(samples)

    for gene in genes:
        num_samples = len(sequences[gene])
        if (num_samples / total_samples) >= (gene_threshold / 100):
            filtered_genes.add(gene)
            print(f"Gene {gene} passed filter with {num_samples}/{total_samples} samples")

    print(f"Genes after filtering: {len(filtered_genes)}")
    return filtered_genes

def write_filtered_fasta(sequences, samples, genes, output_dir):
    """Write the filtered sequences to new FASTA files."""
    if not os.path.exists(output_dir):
        print(f"Creating output directory: {output_dir}")
        os.makedirs(output_dir, exist_ok=True)

    for gene in genes:
        output_file = os.path.join(output_dir, f"{gene}.fasta")
        print(f"Writing to {output_file}...")
        with open(output_file, "w") as output_handle:
            for sample in samples:
                if sample in sequences[gene]:
                    output_handle.write(f">{sample}\n{sequences[gene][sample]}\n")
                    print(f"  Wrote sample {sample} for gene {gene}")

def main():
    input_directory = "/cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/chloroplast/filtered_chloroplast_subset_updated"
    output_base_dir = "/cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/chloroplast/filtered_chloroplast_subset_updated_filteredagain"

    sequences, samples, genes = parse_fasta_files(input_directory)

    # Define the filtering thresholds
    sample_thresholds = [80]
    gene_thresholds = [80]

    for sample_threshold in sample_thresholds:
        for gene_threshold in gene_thresholds:
            print(f"\nFiltering with sample threshold {sample_threshold}% and gene threshold {gene_threshold}%...")

            # Order 1: Remove samples first, then genes
            print("\nOrder 1: Remove samples first, then genes")
            filtered_samples = filter_samples(sequences, samples, genes, sample_threshold)
            filtered_genes = filter_genes(sequences, filtered_samples, genes, gene_threshold)

            output_dir = os.path.join(output_base_dir, f"sample_{sample_threshold}_gene_{gene_threshold}")
            write_filtered_fasta(sequences, filtered_samples, filtered_genes, output_dir)
            print(f"Filtered files written to {output_dir}")

            # Order 2: Remove genes first, then samples
            #print("\nOrder 2: Remove genes first, then samples")
            #filtered_genes = filter_genes(sequences, samples, genes, gene_threshold)
            #filtered_samples = filter_samples(sequences, samples, filtered_genes, sample_threshold)

            #output_dir = os.path.join(output_base_dir, f"gene_first/sample_{sample_threshold}_gene_{gene_threshold}")
            #write_filtered_fasta(sequences, filtered_samples, filtered_genes, output_dir)
            #print(f"Filtered files written to {output_dir}")

if __name__ == "__main__":
    main()