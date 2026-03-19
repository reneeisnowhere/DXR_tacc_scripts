#!/bin/bash

#SBATCH -J computeLTR
#SBATCH -o compmatLTR.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=250G
#SBATCH -t 01:00:00
#SBATCH --array=1-100%10



module unload xalt
module load tacc-apptainer
module load biocontainers
module load deeptools

BED_DIR=/scratch/09196/reneem/ChromHMM_DXR/TE_BED_chunks

BW_DIR=/scratch/09196/reneem/ChromHMM_DXR/Big_wig/merged_bigwig

OUT_DIR=/scratch/09196/reneem/ChromHMM_DXR/computeMatrix_output/LTR

mkdir -p $OUT_DIR

BED_FILE=$(ls $BED_DIR/LTR_chunk_* | sort | sed -n "${SLURM_ARRAY_TASK_ID}p")
NAME=$(basename $BED_FILE)

echo "Processing $BED_FILE"

computeMatrix scale-regions \
	-S $BW_DIR/*.bw \
	-R $BED_FILE \
	-b 2000 -a 2000 \
	--regionBodyLength 5000 \
	--skipZeros \
	--missingDataAsZero \
	-p 32\
       	-o $OUT_DIR/matrix_${NAME}.gz

