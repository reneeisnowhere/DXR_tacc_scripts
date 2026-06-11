#!/bin/bash

#SBATCH -J AME_mer
#SBATCH -o mer_active3vmer.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 03:30:00

echo $(date) "Starting process"
module load tacc-apptainer


FASTA_DIR=/scratch/09196/reneem/memesuite/fa_files
OUT_DIR=/scratch/09196/reneem/memesuite/AME_H3K27ac_active3_MER61E_output
KZFP_MOTIFS=/scratch/09196/reneem/memesuite/motif_databases/JASPAR/JASPAR2024_CORE_vertebrates_non-redundant_v2.meme

cd /scratch/09196/reneem/memesuite

mkdir -p $OUT_DIR


apptainer exec --bind $FASTA_DIR:/home/fasta,$OUT_DIR:/home/ame /scratch/09196/reneem/memesuite/memesuite_latest.sif ame \
	--oc $OUT_DIR --method fisher --control "/home/fasta/MER61E_ERV1_LTR.fa" "/home/fasta/MER61E_set3_active.fa" $KZFP_MOTIFS

echo $(date) " done"
