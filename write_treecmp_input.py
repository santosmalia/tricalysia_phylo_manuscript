import os

# Define paths
input_dir = "simulated_genetrees_rooted_mpest"  # Directory containing the tree files
output_file = "simulated_mpest_treecmp_input.tre"  # Output file

# Open the output file in append mode
with open(output_file, "w") as outfile:
    # Loop through numbers 1 to 10,000
    for i in range(1, 10001):
        # Construct the input file path
        input_file = os.path.join(input_dir, f"gtree{i}.tre")
        
        # Check if the input file exists
        if os.path.exists(input_file):
            # Read the content of the input file
            with open(input_file, "r") as infile:
                content = infile.read().strip()  # Read and remove any trailing whitespace
                outfile.write(content)  # Write the content to the output file
                print(f"Processed gtree{i}.tre")  # Print progress
        else:
            print(f"File gtree{i}.tre not found. Skipping.")

# Add newlines after each semicolon in the output file
with open(output_file, "r+") as file:
    content = file.read()  # Read the entire file content
    content = content.replace(";", ";\n")  # Replace all semicolons with semicolon + newline
    file.seek(0)  # Move the file pointer to the beginning
    file.write(content)  # Write the modified content back to the file
    file.truncate()  # Truncate any remaining content (in case the new content is shorter)

print(f"All trees have been concatenated and formatted in {output_file}.")