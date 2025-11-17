#!/bin/bash

#SBATCH -J merge_bams
#SBATCH -o merge_bams.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=32G
#SBATCH -t 4:00:00



module unload xalt

module load samtools

cd /scratch/09196/reneem/ChromHMM_DXR

INFO_FILE="DXR_recovery_sample_info.tsv"
BAM_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_sorted"
MERGED_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_merged"
CELLMARK_FILE="/scratch/09196/reneem/ChromHMM_DXR/cellmarkfile.txt"
mkdir -p $MERGED_DIR

> $CELLMARK_FILE


## read file, skipping header
tail -n +2 "$INFO_FILE" | awk '{print $2"\t"$4"\t"$5}' | sort | uniq | while read MARK TREAT TIME; do

	#generate merged name for bam

	MERGED_BAM=$MERGED_DIR/${MARK}_${TREAT}_${TIME}_merged.bam

	# Find all matching BAMs
    BAM_LIST=$(awk -v m="$MARK" -v t="$TREAT" -v tp="$TIME" '$2==m && $4==t && $5==tp {print $1}' $INFO_FILE | \
               xargs -I{} find $BAM_DIR -name "{}*_final.bam" | tr '\n' ' ')

    echo "Merging $BAM_LIST into $MERGED_BAM"

    samtools merge -@ 4 $MERGED_BAM $BAM_LIST
    samtools index $MERGED_BAM

    ##add entry into cellmarkfile.txt

    echo "genome \"${MARK}_${TREAT}_${TIME}\" $MERGED_BAM" >> $CELLMARK_FILE
    done
        echo "DONE Merged BAMs in $MERGED_DIR and cellmarkfile.txt genrated at $CELLMARK_FILE"


