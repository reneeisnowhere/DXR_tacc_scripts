#!/bin/bash

#SBATCH -J Enrichment
#SBATCH -o enrich16.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=64G
#SBATCH -t 3:00:00



module unload xalt
#module load openjdk
module load tacc-apptainer
module load biocontainers


echo "Script started at: $START"
CHROMHMM="/scratch/09196/reneem/ChromHMM_DXR/ChromHMM/ChromHMM.jar"
MODEL_DIR="/scratch/09196/reneem/ChromHMM_DXR/Chrom_model_16states_final"
OUT_DIR="/scratch/09196/reneem/ChromHMM_DXR/16-internal-enrichment"

mkdir -p "$OUT_DIR"
cd "$OUT_DIR" || exit 1

echo "Computing internal overlap enrichment using ChromHMM COORDS/hg38"

for SEGMENTS in "$MODEL_DIR"/*_segments.bed; do
    PREFIX=$(basename "$SEGMENTS" _segments.bed)

    echo "→ $PREFIX"

    java -Djava.awt.headless=true -Xmx60G -jar "$CHROMHMM" \
        OverlapEnrichment \
        "$SEGMENTS" \
        hg38 \
        "$PREFIX" \
        > "${PREFIX}.log" 2>&1
done

echo "✔ Internal enrichment complete"



