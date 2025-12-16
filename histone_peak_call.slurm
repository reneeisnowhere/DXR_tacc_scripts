#!/bin/bash

#SBATCH -J macs3calls
#SBATCH -o histon_peaks.%j
#SBATCH -p vm-small
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 12:00:00



module unload xalt
#module load openjdk
module load tacc-apptainer
module load biocontainers
module load macs3

START=$(date)

echo "Script started at: $START"

cd /scratch/09196/reneem/ChromHMM_DXR


BAM_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_merged"
CONTAINER="/scratch/09196/reneem/ChromHMM_DXR/macs3.sif"
OUT_DIR="/scratch/09196/reneem/ChromHMM_DXR/final_peaks"

mkdir -p "$OUT_DIR"

#### looping over bams

for Bam in ${BAM_DIR}/*_merged.bam;do
	BASENAME=$(basename "$Bam" .bam)

	### default q value
	QVAL=0.001

	##H3K27ac is 0.01 though
	if [[ "$BASENAME" == H3K27ac* ]]; then
		QVAL=0.01
	fi
	echo "Running MACS3 on $BASENAME with q=${QVAL}"

	apptainer exec "$CONTAINER" \
		macs3 callpeak -t "$Bam" -f BAMPE -g hs --keep-dup all --nomodel --nolambda -q "$QVAL" -n "${BASENAME}_final" \
		--outdir "$OUT_DIR"
done

echo "EVERYTHING is completed"


