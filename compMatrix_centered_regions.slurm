#!/bin/bash

#SBATCH -J computeMatrix
#SBATCH -o compREG.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 05:30:00
#SBATCH --array=1-14%8



module unload xalt
module load tacc-apptainer
module load biocontainers
module load deeptools

BED_DIR=/scratch/09196/reneem/ChromHMM_DXR/comp_bed_sets

BW_DIR=/scratch/09196/reneem/ChromHMM_DXR/Big_wig/merged_bigwig

OUT_DIR=/scratch/09196/reneem/ChromHMM_DXR/computeMatrix_output_centeredregions

mkdir -p $OUT_DIR

BED_FILE=$(ls $BED_DIR/*.bed | sed -n "${SLURM_ARRAY_TASK_ID}p")
NAME=$(basename $BED_FILE .bed)

echo "Processing $BED_FILE"

computeMatrix reference-point \
	-S $BW_DIR/*.bw \
	-R $BED_FILE \
	-b 2000 -a 2000 \
	-bs 10 \
	--skipZeros \
	--missingDataAsZero \
	-p 8\
       	-o $OUT_DIR/matcenter_${NAME}.gz

