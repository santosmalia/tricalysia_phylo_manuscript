### Tricalysia manuscript 2025

## 1. Raw read trimming - trim_tricalysia_fq.slurm
# Cleaning raw reads with Trimmomatic to remove adaptor sequences and remove short reads (Bolger et al. 2014). 

## 2. Sequence assembly - hybpiper.slurm
# Cleaned reads were mapped to the Angiosperm-353 target genes using HybPiper v.2.3.2 (Johnson et al. 2016). To maximize sequence recovery, we created a more specific target file using NewTargets to tailor our target file to Rubiaceae taxa (McLay et al. 2021). Read mapping was performed using HybPiper2, which employs the Burrows–Wheeler Aligner for initial read recruitment to target sequences (Li and Durbin 2009). Gene recovery and assembly were conducted using the HybPiper2 workflow, which integrates reference-guided assembly approaches. Exon sequences were aligned and scaffolded using ‘exonerate’, while intronic regions were recovered using ‘run-intronerate’ to extract non-exonic sequences (Bankevich et al. 2012). Finally, we used ‘retrieve sequences’ to compile both exon and intron sequences for downstream phylogenomic analyses.

## 3. Sequence alignment - 
# After recovering supercontig sequences from HybPiper v.2.3.2, sequences were aligned using MAFFT (Katoh et al. 2002). 

## 4. Sequence filtering - fasta_filtering_script.py
# To assess the implications of missing data we used a custom Python script (fasta_filtering_script.py) to remove samples if they were not present in a percentage of the genes (30, 50, 70) and then to remove genes that did not have specified percentages (30, 50, 70) of the samples. The filtered, aligned datasets were cleaned using ‘phyutility’ to remove sites that were missing 50% data (clean −0.5), producing our final filtered datasets (Smith and Dunn 2008).

## 5. Phylogenetic tree reconstruction - phylogenetics_tricalysia.slurm
# Phylogenetic tree reconstruction using IQ-tree2 for gene trees and  concatenated phylogenetic hypotheses and ASTRAL-III for species tree estimates.
