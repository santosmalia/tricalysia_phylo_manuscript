import argparse
from Bio import Phylo

def estimate_theta(input_tree, output_theta):
    print(f"Loading tree from {input_tree}")

    # Load the input tree
    try:
        tree = Phylo.read(input_tree, 'newick')
        print("Tree loaded successfully.")
    except Exception as e:
        print(f"Error loading tree: {e}")
        return

    print("Estimating theta for internal branches...")

    # Estimate theta for internal branches (T/θ)
    theta_values = []
    internal_id = 0  # Unique identifier for internal branches

    for clade in tree.find_clades():
        if not clade.is_terminal():  # Only internal branches
            if clade.branch_length is not None:
                theta = clade.branch_length  # Assuming branch length is in coalescent units
                theta_values.append((f"internal_{internal_id}", theta))
                print(f"Internal clade {internal_id}: Theta = {theta}")
                internal_id += 1
            else:
                print(f"Warning: Internal clade {internal_id} has no branch length!")

    # Save theta values to a file
    try:
        with open(output_theta, 'w') as f:
            for clade_name, theta in theta_values:
                f.write(f"{clade_name}\t{theta}\n")
        print(f"Theta values saved to {output_theta}")
    except Exception as e:
        print(f"Error writing theta values: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Estimate theta (T/θ) for internal branches.")
    parser.add_argument("--input_tree", required=True, help="Path to the input tree file.")
    parser.add_argument("--output_theta", required=True, help="Path to the output theta file.")
    args = parser.parse_args()
    
    estimate_theta(args.input_tree, args.output_theta)
