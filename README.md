# Tricalysia Phylogenomics Pipeline (2025)

This repository contains scripts and workflows used for phylogenomic analyses of *Tricalysia* using target enrichment (Angiosperm353) data.

## Workflow Overview

1. Raw read trimming
2. Sequence assembly and target recovery
3. Sequence alignment
4. Sequence filtering
5. Phylogenetic tree reconstruction

---

## 1. Raw Read Trimming

**Script:** `trim_tricalysia_fq.slurm`

Raw sequencing reads were cleaned using Trimmomatic to remove adapter contamination and low-quality or short reads (Bolger et al. 2014).

---

## 2. Sequence Assembly and Target Recovery

**Script:** `hybpiper.slurm`

Cleaned reads were mapped to the Angiosperm353 target loci using HybPiper v2.3.2 (Johnson et al. 2016).

To maximize sequence recovery, a Rubiaceae-specific target file was generated using NewTargets (McLay et al. 2021). Read mapping was performed using the Burrows–Wheeler Aligner (BWA; Li and Durbin 2009) within the HybPiper2 workflow.

Gene assembly and recovery included:

- Reference-guided assembly of target loci
- Exon alignment and scaffolding using `exonerate`
- Recovery of intronic regions using `run_intronerate`
- Extraction of exon and supercontig sequences using `retrieve_sequences`

The resulting exon and supercontig datasets were used for downstream phylogenomic analyses.

---

## 3. Sequence Alignment

Recovered supercontig sequences were aligned using MAFFT (Katoh et al. 2002).

---

## 4. Sequence Filtering

**Script:** `fasta_filtering_script.py`

To evaluate the effects of missing data, a custom Python script was used to generate datasets with varying completeness thresholds.

Filtering was performed in two steps:

1. Remove samples present in less than 30%, 50%, or 70% of loci.
2. Remove loci present in less than 30%, 50%, or 70% of samples.

Filtered alignments were subsequently cleaned using Phyutility (Smith and Dunn 2008) to remove sites with more than 50% missing data (`clean -0.5`).

This produced the final datasets used for phylogenetic analyses.

---

## 5. Phylogenetic Tree Reconstruction

**Scripts:** `phylogenetics_tricalysia.slurm` `astral.slurm`

Phylogenetic relationships were inferred using both concatenation and coalescent-based approaches.

### Gene Trees

Individual gene trees were estimated using IQ-TREE 2.

### Concatenated Analyses

Concatenated phylogenetic hypotheses were reconstructed using IQ-TREE 2.

### Species Tree Estimation

Species trees were inferred from gene trees using ASTRAL-III.


## 6. Phyparts
**Scripts:** `phyparts.pieplot.slurm`

---

## 7. RevBayes
**Scripts:** `revbayes_tricalysia_2025.txt`

---

## 8. Coalesccent Simulations
**Scripts:** `coalescent_simulations.slurm`

## References

- Bankevich, A. et al. 2012.
- Bolger, A.M. et al. 2014.
- Johnson, M.G. et al. 2016.
- Katoh, K. et al. 2002.
- Li, H. and Durbin, R. 2009.
- McLay, T.G.B. et al. 2021.
- Smith, S.A. and Dunn, C.W. 2008.
