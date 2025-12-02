import os
import glob
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from Bio import SeqIO

def parse_fasta(directory):
    presence_absence = {}
    fasta_files = glob.glob(os.path.join(directory, "*.fasta"))
    
    if not fasta_files:
        print("Error: No FASTA files found in the directory.")
        return None
    
    for fasta_file in fasta_files:
        gene_name = os.path.basename(fasta_file).replace(".fasta", "")
        
        for record in SeqIO.parse(fasta_file, "fasta"):
            individual_id = record.id
            
            if individual_id not in presence_absence:
                presence_absence[individual_id] = {}
            
            presence_absence[individual_id][gene_name] = 1  # Gene present
    
    return presence_absence

def create_dataframe(presence_absence):
    if not presence_absence:
        print("Error: No presence/absence data found.")
        return None
    df = pd.DataFrame.from_dict(presence_absence, orient='index').fillna(0)
    df = df.astype(int)  # Convert to integer presence/absence data
    return df

def plot_heatmap(df, output_file):
    if df is None or df.empty:
        print("Error: DataFrame is empty. Cannot generate heatmap.")
        return
    plt.figure(figsize=(80, 40))
    sns.heatmap(df, cmap=["red", "blue"], linewidths=0.5, cbar_kws={'label': 'Presence (1) / Absence (0)'})
    plt.xlabel("Genes")
    plt.ylabel("Individuals")
    plt.title("Gene Presence-Absence Heatmap")
    plt.xticks(rotation=90)
    plt.yticks(rotation=0)
    plt.tight_layout()
    plt.savefig(output_file)
    plt.show()

def top_10_genes(df):
    if df is None or df.empty:
        print("Error: DataFrame is empty. Cannot compute top 10 genes.")
        return
    gene_counts = df.sum(axis=0).sort_values(ascending=False)
    top_10 = gene_counts.head(10)
    print("Top 10 Genes with Most Coverage:")
    print(top_10)

def main(directory, output_file):
    presence_absence = parse_fasta(directory)
    if presence_absence is None:
        return
    df = create_dataframe(presence_absence)
    if df is None:
        return
    plot_heatmap(df, output_file)
    top_10_genes(df)

if __name__ == "__main__":
    input_directory = "/cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/chloroplast/filtered_chloroplast_subset_updated"  # Change to your directory
    output_image = "/cluster/medbow/project/tanklab/msantos2/castilleja/all_castilleja_samples/chloroplast/filtered_chloroplast_subset_updated/gene_presence_heatmap_chlr_angio.png"
    main(input_directory, output_image)
