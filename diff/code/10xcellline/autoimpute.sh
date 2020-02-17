#!/bin/bash -l
#SBATCH --mem=50G
#SBATCH --partition=lrgmem
#SBATCH --time=15:00:00
#SBATCH --ntasks-per-node=24

ml R
Rscript /home-4/whou10@jhu.edu/scratch/Wenpin/rna_imputation/diff/code/10xcellline/diff.R autoimpute
