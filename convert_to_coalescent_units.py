import argparse
from Bio import Phylo

def convert_to_coalescent_units(input_tree, output_tree):
    # Load the input tree
    tree = Phylo.read(input_tree, 'newick')
    
    # Convert branch lengths to coalescent units (T/4N)
    for clade in tree.find_clades():
        if clade.branch_length is not None:
            clade.branch_length /= 4  # Assuming 4N is the scaling factor
    
    # Save the converted tree
    Phylo.write(tree, output_tree, 'newick')
    print(f"Converted tree saved to {output_tree}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert branch lengths from mutational units to coalescent units.")
    parser.add_argument("--input_tree", required=True, help="Path to the input tree file.")
    parser.add_argument("--output_tree", required=True, help="Path to the output tree file.")
    args = parser.parse_args()
    
    convert_to_coalescent_units(args.input_tree, args.output_tree)