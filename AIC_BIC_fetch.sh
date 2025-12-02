#!/bin/bash

set -e

BASE="/scratch/09196/reneem/ChromHMM_DXR"
BIN_DIR="$BASE/Binarized_files"
MARKS=4

echo "======================================"
echo " Step 1: Computing total bins (N)"
echo "======================================"

# Get the FIRST sample folder inside Binarized_files
SAMPLE=$(ls -d $BIN_DIR/*/ | head -n 1)

echo "Using sample folder: $SAMPLE"

# Count bins by summing lines of all chr*.txt files
N=15441385

echo "Total bins (N) = $N"
echo

echo "======================================"
echo " Step 2: Model AIC/BIC extraction"
echo "======================================"

# Output file
OUTFILE="$BASE/model_selection_summary.tsv"
echo -e "States\tLogLikelihood\tAIC\tBIC" > $OUTFILE

# Loop through each model folder
for folder in $BASE/Chrom_model_*states; do

    # Extract number of states from folder name
    STATES=$(basename "$folder" | sed -E 's/Chrom_model_([0-9]+)states/\1/')

    LOGFILE="$folder/more_log.txt"

    if [[ ! -f "$LOGFILE" ]]; then
        echo "Skipping $folder (no more_log.txt)"
        continue
    fi

    echo "Processing $folder ..."

    # Extract the final log-likelihood = last line containing an iteration #
    LL=$(grep -E "^[[:space:]]*[0-9]+[[:space:]]" "$LOGFILE" | tail -n 1 | awk '{print $2}')

    if [[ -z "$LL" ]]; then
        echo "❌ Could not extract log-likelihood for $STATES states"
        continue
    fi

    # Number of free parameters: S(M + 1)
    K=$((STATES * (MARKS + 1)))

    # Compute AIC and BIC
    AIC=$(echo "scale=4; (2 * $K) - (2 * $LL)" | bc)
    BIC=$(echo "scale=4; ($K * l($N)) - (2 * $LL)" | bc -l)

    # Append to summary
    echo -e "${STATES}\t${LL}\t${AIC}\t${BIC}" >> $OUTFILE
done

echo
echo "======================================"
echo " Results written to:"
echo "   $OUTFILE"
echo "======================================"

