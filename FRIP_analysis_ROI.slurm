#!/bin/bash

#SBATCH -J FRIP
#SBATCH -o FRIP.%j
#SBATCH -p vm-small
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 6:00:00



module unload xalt
#module load openjdk
module load tacc-apptainer
module load biocontainers
module load bedtools


BASE_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_sorted"
OUT_DIR="/scratch/09196/reneem/ChromHMM_DXR"
BED_DIR="/scratch/09196/reneem/ChromHMM_DXR/ROI_files"
HISTONES=("H3K27ac" "H3K27me3" "H3K36me3" "H3K9me3")
TREATMENT=("DOX" "VEH")
TIME=("24T" "24R" "144R")
OUTPUT="$OUT_DIR/FRIP_scores_2ndrun.txt"
SAMTOOLS="/scratch/09196/reneem/ChromHMM_DXR/samtools_1.9--h91753b0_5.sif"



cd "$BASE_DIR"

echo -e "Histone\tTX_Time\tSample\tReads_in_Peaks\tTotal_Reads\tFRiP" > "$OUTPUT"

for HISTONE in "${HISTONES[@]}"; do
	ROI_FILE="${BED_DIR}/all_${HISTONE}_ROI.bed"

	[[ -f "$ROI_FILE" ]] || { echo "Missing ROI: $ROI_FILE"; continue; }

	for TREAT in "${TREATMENT[@]}"; do
		for T in "${TIME[@]}"; do

	BAM_DIR="${BASE_DIR}/${HISTONE}/${TREAT}/${T}"

	[[ -d "$BAM_DIR" ]] || continue

	for BAM in "${BAM_DIR}"/*.bam; do

		[[ -e "$BAM" ]] || continue

		BASENAME=$(basename "$BAM" noM_final.bam)


		READS_IN_PEAKS=$(bedtools intersect -abam "$BAM" -b "$ROI_FILE" -bed | wc -l)
		TOTAL_READS=$(apptainer exec "$SAMTOOLS" samtools view -c -F 0x4 "$BAM")
		FRIP=$(awk -v r="$READS_IN_PEAKS" -v t="$TOTAL_READS" 'BEGIN { if (t>0) printf "%.4f", r/t; else print "NA" }')
	echo -e "${HISTONE}\t${TREAT}_${T}\t${BASENAME}\t${READS_IN_PEAKS}\t${TOTAL_READS}\t${FRIP}" >> "$OUTPUT"

	done

done
done
done


echo "DONE" 



