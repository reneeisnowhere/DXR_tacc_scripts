#!/bin/bash

#SBATCH -J binarize_bams
#SBATCH -o binarize_bams.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=64G
#SBATCH -t 12:00:00



module unload xalt
module load java
module load tacc-apptainer
module load biocontainers



cd /scratch/09196/reneem/ChromHMM_DXR


CHROMHMM="/scratch/09196/reneem/ChromHMM_DXR/ChromHMM/ChromHMM.jar"

INFO_FILE="DXR_recovery_sample_info.tsv"
OUTPUT_DIR="/scratch/09196/reneem/ChromHMM_DXR/Binarized_files"
BAM_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_merged"
CELLMARK_FILE="/scratch/09196/reneem/ChromHMM_DXR/cellmarkfile.txt"
CHROMSIZES="/scratch/09196/reneem/ChromHMM_DXR/hg38.chrom.sizes"

mkdir -p $OUTPUT_DIR

java -Xmx60G -jar "$CHROMHMM" BinarizeBam -b 200 "$CHROMSIZES" "" "$CELLMARK_FILE" "$OUTPUT_DIR"




