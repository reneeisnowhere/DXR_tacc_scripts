#!/bin/bash

#SBATCH -J Enrichment
#SBATCH -o enrATAC.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=64G
#SBATCH -t 3:00:00



module unload xalt
module load tacc-apptainer
module load biocontainers


START=$(date)

echo "Script started at: $START"

CHROMHMM="/scratch/09196/reneem/ChromHMM_DXR/ChromHMM/ChromHMM.jar"

BED_DIR="/scratch/09196/reneem/ChromHMM_DXR/bed_sets"
MODEL_BASE="/scratch/09196/reneem/ChromHMM_DXR/Chrom_model_16states_final"
#CHROMSIZES="/scratch/09196/reneem/ChromHMM_DXR/hg38.chrom.sizes"
OUT_DIR="/scratch/09196/reneem/ChromHMM_DXR/overlap_enrichment_all/ATAC_run"

mkdir -p "$OUT_DIR"
cd "$OUT_DIR" || exit 1
	
# Loop over all segmentation files

find "$MODEL_BASE" -name "*_segments.bed" | sort | while read -r SEGMENTS; do

	##Extract useful names
	SEG_BASENAME=$(basename "$SEGMENTS")
	MODEL_NAME=$(basename "$(dirname "SEGMENTS")")

	PREFIX=${SEG_BASENAME%_segments.bed}

	echo "------------------------------------------------------"
	echo "Running Overlap Enricment for:"
	echo "	Segemnation:	$SEG_BASENAME"
	echo " 	Model dir:	$MODEL_NAME"
	echo "	Prefix:		$PREFIX"
	echo "------------------------------------------------------"


	java -Djava.awt.headless=true -Xmx60G -jar "$CHROMHMM" OverlapEnrichment -labels "$SEGMENTS" "$BED_DIR" "$PREFIX" > "${PREFIX}.log" 2>&1

done


END=$(date)

echo " OE started at $START and finished at $END"
