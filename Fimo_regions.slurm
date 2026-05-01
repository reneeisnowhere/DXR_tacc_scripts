#!/bin/bash

#SBATCH -J FIMO
#SBATCH -o Fimo.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 03:30:00

echo $(date) "Starting process"
module load tacc-apptainer


FASTA_DIR=/scratch/09196/reneem/memesuite/fa_files
OUT_DIR=/scratch/09196/reneem/memesuite/fimo_results/H3K27ac_KZFP_fimo
TP53_MOTIF=/scratch/09196/reneem/memesuite/motif_databases/KZFP_motifs.meme

cd /scratch/09196/reneem/memesuite

mkdir -p $OUT_DIR



apptainer exec --bind $FASTA_DIR:/home/fasta,$OUT_DIR:/home/fimo_out /scratch/09196/reneem/memesuite/memesuite_latest.sif fimo \
	--oc /home/fimo_out \
	--thresh 1e-4 \
	$TP53_MOTIF \
	/home/fasta/H3K27ac_summit_gr_ext200.fa \


echo $(date) " done"
