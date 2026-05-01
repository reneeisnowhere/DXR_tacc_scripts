#!/bin/bash

BED_LIST="bed_file_list_temp.txt"

BED_DIR="/scratch/09196/reneem/ChromHMM_DXR/bed_sets"
OUT_DIR="/scratch/09196/reneem/ChromHMM_DXR/computeMatrix_output_centered2histone"

DONE_DIR="/scratch/09196/reneem/ChromHMM_DXR/already_run_bed_files"
INCOMPLETE_LOG="$BED_DIR/incomplete_beds.txt"

mkdir -p "$DONE_DIR"
rm -f "$INCOMPLETE_LOG"

echo "Checking completed computeMatrix jobs..."

while read bed; do
    NAME=$(basename "$bed" .bed)
    OUTFILE="$OUT_DIR/matcenter_${NAME}.gz"

    # check if output exists and is non-empty
    if [ -s "$OUTFILE" ]; then
        mv "$bed" "$DONE_DIR/"
        echo "MOVED: $bed"
    else
        echo "INCOMPLETE: $bed" >> "$INCOMPLETE_LOG"
        echo "MISSING: $bed"
    fi

done < "$BED_LIST"

echo "Done."
echo "Incomplete list saved to: $INCOMPLETE_LOG"
