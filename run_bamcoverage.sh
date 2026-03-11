#!/bin/bash


module load tacc-apptainer

BASE_DIR="/scratch/09196/reneem/ChromHMM_DXR/bams_sorted"
CONTAINER="/scratch/09196/reneem/ChromHMM_DXR/deeptools_3.5.5.sif"
BW_BASE="/scratch/09196/reneem/ChromHMM_DXR/Big_wig"


find $BASE_DIR -name "*.bam" | while read bam; do

##remove base path
relpath=${bam#$BASE_DIR/}


## remove .bam extension

relpath=${relpath%.bam}

##build output file

outfile=$BW_BASE/${relpath}.bw

## make output dir

mkdir -p $(dirname $outfile)

echo "Processing $bam"

apptainer exec $CONTAINER bamCoverage -b $bam -o $outfile --normalizeUsing CPM --binSize 10 -p 8



done

