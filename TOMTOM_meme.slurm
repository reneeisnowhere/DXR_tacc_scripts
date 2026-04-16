#!/bin/bash

#SBATCH -J Tomtom_meme
#SBATCH -o TT_meme.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 4:00:00

echo $(date) "Starting process"
module load tacc-apptainer


FASTA_DIR=/scratch/09196/reneem/memesuite/fa_files
OUT_DIR=/scratch/09196/reneem/memesuite/JAS_KZFP_compare_results
JASPAR_DIR=/scratch/09196/reneem/memesuite/motif_databases

cd /scratch/09196/reneem/memesuite

mkdir -p $OUT_DIR



apptainer exec --bind $FASTA_DIR:/home/fasta,$OUT_DIR:/home/tomtom_out,$JASPAR_DIR:/home/meme /scratch/09196/reneem/memesuite/memesuite_latest.sif tomtom \
	--oc /home/tomtom_out \
	-evalue /home/meme/KZFP_motifs.meme home/meme/JASPAR/JASPAR2022_CORE_vertebrates_non-redundant_v2.meme


echo $(date) " done"
