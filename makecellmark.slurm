#!/bin/bash

#SBATCH -J cellmark
#SBATCH -o filemakings.%j
#SBATCH -p vm-small
#SBATCH -N 1
#SBATCH -n 1

#SBATCH -t 00:05:00


cd /scratch/09196/reneem/ChromHMM_DXR/bams_merged

OUTFILE="/scratch/09196/reneem/ChromHMM_DXR/cellmarkfile.txt"

# Start with a clean file
> "$OUTFILE"

# Loop over all BAM files
for BAM in *_merged.bam; do
    # Example BAM: H3K27ac_DOX_24T_merged.bam
    BASENAME=$(basename "$BAM" "_merged.bam")  # H3K27ac_DOX_24T
    MARK=$(echo "$BASENAME" | cut -d'_' -f1)    # H3K27ac
    TREAT=$(echo "$BASENAME" | cut -d'_' -f2)   # DOX
    TIME=$(echo "$BASENAME" | cut -d'_' -f3)    # 24T
    CELL="${TIME}_${TREAT}"                      # 24T_DOX

    echo -e "${CELL}\t${MARK}\t$(pwd)/${BAM}" >> "$OUTFILE"
done

echo "Stacked cellmarkfile generated at $OUTFILE"
