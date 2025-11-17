#!/bin/bash

#SBATCH -J sort_bams
#SBATCH -o sort_bams.%j
#SBATCH -p vm-small
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1:00:00


cd /scratch/09196/reneem/ChromHMM_DXR

INFO_FILE="DXR_recovery_sample_info.tsv"
BAM_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_filtered"
OUT_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_sorted"


## read file, skipping header
tail -n +2 "$INFO_FILE" | while read -r LIBRARY HISTONE INDIV TREATMENT TIMEPOINT
do
	## Extract BAM name
	BAM="${LIBRARY}_noM_final.bam"
	SRC="$BAM_DIR/$BAM"

	### Create destination structure
	DEST_DIR="$OUT_DIR/$HISTONE/$TREATMENT/$TIMEPOINT"
	mkdir -p "$DEST_DIR"


	##move files
	if [[ -f "$SRC" ]]; then
            echo "Moving $BAM → $DEST_DIR"
            mv "$SRC" "$DEST_DIR/"
         else
        echo "WARNING: BAM not found: $SRC"
    fi
done


