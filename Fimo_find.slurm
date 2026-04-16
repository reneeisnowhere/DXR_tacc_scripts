#!/bin/bash

#SBATCH -J Tomtom
#SBATCH -o Tomtom.%a%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 00:30:00
#SBATCH --array=1-25%8
#SBATCH --mem=64G

echo $(date) "Starting process"
module load tacc-apptainer


FASTA_DIR=/scratch/09196/reneem/memesuite/fa_files
OUT_DIR=/scratch/09196/reneem/memesuite/fimo_results
TP53_MOTIF=/scratch/09196/reneem/memesuite/motif_databases/TP53_half_motif_paper_pwm.meme

cd /scratch/09196/reneem/memesuite

mkdir -p $OUT_DIR

TARGET=$(awk -F'\t' "NR==$SLURM_ARRAY_TASK_ID {print \$1}" $FASTA_DIR/fasta_pairs.txt)
TARGET="$FASTA_DIR/$TARGET"

echo "Running seas fimo  target: $TARGET"
BASENAME=$(basename $TARGET .fa)
TARGET_OUT=$OUT_DIR/${BASENAME}_fimo

mkdir -p "$TARGET_OUT"


apptainer exec --bind $FASTA_DIR:/home/fasta,$OUT_DIR:/home/xstreme /scratch/09196/reneem/memesuite/memesuite_latest.sif fimo \
	--oc $TARGET_OUT \
	--thresh 1e-4 \
	$TP53_MOTIF \
	$TARGET \


echo $(date) " done"
