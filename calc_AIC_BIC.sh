#!/bin/bash

# === User settings ===
BIN_DIR="/scratch/09196/reneem/ChromHMM_DXR/Binarized_files"
MODEL_BASE="/scratch/09196/reneem/ChromHMM_DXR"
OUTPUT="model_selection_results.tsv"
MARKS=4

echo -e "states\tlogLik\tparams\tAIC\tBIC" > "$OUTPUT"

# --- Step 1: compute sample size N (same for all samples) ---
#cd "$BIN_DIR"
echo "Counting total bins N from binarized files..."
N=15441385
echo "Total bins (N) = $N"
echo

# Natural log of N
LN_N=$(awk -v n="$N" 'BEGIN {print log(n)}')

# --- Step 2: loop over model folders ---
cd "$MODEL_BASE"

for dir in Chrom_model_*states; do
    if [ ! -f "$dir/more_log.txt" ]; then
        echo "Skipping $dir (no more_log.txt)"
        continue
    fi

    # Extract number of states from folder name
    STATES=$(echo "$dir" | sed -E 's/Chrom_model_([0-9]+)states/\1/')

    LOG="$dir/more_log.txt"

    # Extract FINAL log-likelihood (last numeric entry in the iteration table)
    L=$(grep -E "^[ ]*[0-9]+[ ]+-" "$LOG" | awk '{print $2}' | tail -n 1)

    if [ -z "$L" ]; then
        echo "⚠ Could not find log-likelihood in $dir"
        continue
    fi

    # Number of parameters p = K( M + K )
    P=$(awk -v K="$STATES" -v M="$MARKS" 'BEGIN { print K*(M+K) }')

    # Compute AIC and BIC
    AIC=$(awk -v L="$L" -v P="$P" 'BEGIN { print -2*L + 2*P }')
    BIC=$(awk -v L="$L" -v P="$P" -v lnN="$LN_N" 'BEGIN { print -2*L + P*lnN }')

    # Write results
    echo -e "${STATES}\t${L}\t${P}\t${AIC}\t${BIC}" >> "$OUTPUT"

    echo "Processed: $dir (states=$STATES)"
done

echo
echo "Done! Results written to: $OUTPUT"

