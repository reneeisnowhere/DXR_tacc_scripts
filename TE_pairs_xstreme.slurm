#!/bin/bash

#SBATCH -J TE_pairs
#SBATCH -o TE_xstreme.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -t 4:00:00
#SBATCH --array=1-25%8
#SBATCH --mem=64G

echo $(date) "Starting process"
module load tacc-apptainer


FASTA_DIR=/scratch/09196/reneem/memesuite/fa_files
OUT_DIR=/scratch/09196/reneem/memesuite/TE_xstreme_results
DB_DIR=/scratch/09196/reneem/memesuite/motif_databases

cd /scratch/09196/reneem/memesuite

mkdir -p $OUT_DIR

TARGET=$(awk -F'\t' "NR==$SLURM_ARRAY_TASK_ID {print \$1}" $FASTA_DIR/fasta_pairs.txt)
BACKGROUND=$(awk -F'\t' "NR==$SLURM_ARRAY_TASK_ID {print \$2}" $FASTA_DIR/fasta_pairs.txt)

echo "Running xstreme for target: $TARGET background: $BACKGROUND"
BASENAME=$(basename $TARGET .fa)


apptainer exec --bind $FASTA_DIR:/home/fasta,$OUT_DIR:/home/xstreme,$DB_DIR:/home/meme /scratch/09196/reneem/memesuite/memesuite_latest.sif xstreme \
	--oc /home/xstreme/${BASENAME}_xstreme \
	--time 240 --streme-totallength 8000000 --meme-searchsize 100000 \
	--desc "description for $TARGET" \
	--dna --evt 0.05 --minw 6 --maxw 15 --align center \
	--meme-mod zoops \
	--m /home/meme/JASPAR/JASPAR2022_CORE_vertebrates_non-redundant_v2.meme  \
	--p /home/fasta/$TARGET \
	-n /home/fasta/$BACKGROUND


echo $(date) " done"
