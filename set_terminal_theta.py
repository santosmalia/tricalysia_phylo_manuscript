import argparse
from Bio import Phylo

def set_terminal_theta(input_tree, theta_values_file, output_tree):
    # Load the input tree
    tree = Phylo.read(input_tree, 'newick')
    
    # Load theta values for internal branches
    theta_values = {}
    with open(theta_values_file, 'r') as f:
        for line in f:
            clade, theta = line.strip().split('\t')
            theta_values[clade] = float(theta)
    
    # Set terminal branches to theta = 1
    for clade in tree.find_clades():
        if clade.is_terminal():  # Terminal branches
            clade.branch_length = 1.0  # Set theta to 1
        elif clade.name in theta_values:  # Internal branches
            clade.branch_length = theta_values[clade.name]
    
    # Save the modified tree
    Phylo.write(tree, output_tree, 'newick')
    print(f"Modified tree saved to {output_tree}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Set terminal branches with theta = 1.")
    parser.add_argument("--input_tree", required=True, help="Path to the input tree file.")
    parser.add_argument("--theta_values", required=True, help="Path to the theta values file.")
    parser.add_argument("--output_tree", required=True, help="Path to the output tree file.")
    args = parser.parse_args()
    
    set_terminal_theta(args.input_tree, args.theta_values, args.output_tree)