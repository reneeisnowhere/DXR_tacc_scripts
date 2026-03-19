#!/bin/bash

#SBATCH -J computeMatrix
#SBATCH -o compmat.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 00:30:00
#SBATCH --array=201-290%8



module unload xalt
module load tacc-apptainer
module load biocontainers
module load deeptools

BED_DIR=/scratch/09196/reneem/ChromHMM_DXR/bed_sets

BW_DIR=/scratch/09196/reneem/ChromHMM_DXR/Big_wig/merged_bigwig

OUT_DIR=/scratch/09196/reneem/ChromHMM_DXR/computeMatrix_output_2histone

mkdir -p $OUT_DIR

BED_FILE=$(ls $BED_DIR/*.bed | sed -n "${SLURM_ARRAY_TASK_ID}p")
NAME=$(basename $BED_FILE .bed)

echo "Processing $BED_FILE"

computeMatrix scale-regions \
	-S $BW_DIR/*.bw \
	-R $BED_FILE \
	-b 2000 -a 2000 \
	--regionBodyLength 5000 \
	--skipZeros \
	--missingDataAsZero \
	-p 16\
       	-o $OUT_DIR/matrix_${NAME}.gz

