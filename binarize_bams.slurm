#!/bin/bash

#SBATCH -J binarizebams
#SBATCH -o binarize.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1:00:00


cd /scratch/09196/reneem/ChromHMM_DXR

##INFO_FILE="DXR_recovery_sample_info.tsv"
##BAM_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_filtered"
SORTED_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_sorted"
OUTFILE="chromhmm_cells_custom.txt"

## Start with clean file
> "$OUTFILE"

##Loop over dirs
for HISTONE in $(ls "$SORTED_DIR"); do

	##skip if not a directory
	[[ -d "$SORTED_DIR/$HISTONE" ]] || continue

	## scan all BAM files under this histone

	find "$SORTED_DIR/$HISTONE" -type f -name "*.bam" | while read -r BAM
do
	##Example path:  bams_sorted/H3K27ac/DOX/24T/MCW_CT_ROA_78_noM_final.bam

	TREATMENT=$(echo "$BAM" | awk -F'/' '{print $(NF-2)}' | tr -d '\r' | xargs)
	TIMEPOINT=$(echo "$BAM" | awk -F'/' '{print $(NF-1)}' | tr -d '\r' | xargs)

	LABEL="${HISTONE}_${TREATMENT}_${TIMEPOINT}"


	echo -e "genome\t\"${LABEL}\"\t${BAM}" >> "$OUTFILE"
	echo "${LABEL}"
done
done




echo "Finished $OUTFILE"
