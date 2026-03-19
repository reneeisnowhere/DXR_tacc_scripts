#!/bin/bash

#SBATCH -J computeMatrix
#SBATCH -o compmat.%j
#SBATCH -p vm-small
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 02:00:00




module unload xalt
module load tacc-apptainer
module load biocontainers
module load deeptools

BED_DIR=/scratch/09196/reneem/ChromHMM_DXR/already_run_bed_files

BW_DIR=/scratch/09196/reneem/ChromHMM_DXR/Big_wig/merged_bigwiga

OUT_DIR=/scratch/09196/reneem/ChromHMM_DXR/computeMatrix_output

mkdir -p $OUT_DIR

BED_FILE=$BED_DIR/LTR_rptmasker.bed
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

