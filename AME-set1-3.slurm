#!/bin/bash

#SBATCH -J AME
#SBATCH -o AMEset3_1.%a%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 03:30:00

echo $(date) "Starting process"
module load tacc-apptainer


FASTA_DIR=/scratch/09196/reneem/memesuite/fa_files
OUT_DIR=/scratch/09196/reneem/memesuite/AME_H3K27ac_set3vset1_output
KZFP_MOTIFS=/scratch/09196/reneem/memesuite/motif_databases/KZFP_motifs.meme

cd /scratch/09196/reneem/memesuite

mkdir -p $OUT_DIR


apptainer exec --bind $FASTA_DIR:/home/fasta,$OUT_DIR:/home/ame /scratch/09196/reneem/memesuite/memesuite_latest.sif ame \
	--oc $OUT_DIR --method fisher --control "/home/fasta/H3K27ac_Set_1_400.fa" "/home/fasta/H3K27ac_Set_3_400.fa" $KZFP_MOTIFS

echo $(date) " done"
