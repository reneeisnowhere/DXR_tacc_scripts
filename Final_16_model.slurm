#!/bin/bash

#SBATCH -J Learn_model_states
#SBATCH -o LM_states.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=64G
#SBATCH -t 7:00:00



module unload xalt
#module load openjdk
module load tacc-apptainer
module load biocontainers


START=$(date)

echo "Script started at: $START"

cd /scratch/09196/reneem/ChromHMM_DXR


CHROMHMM="/scratch/09196/reneem/ChromHMM_DXR/ChromHMM/ChromHMM.jar"

BINARIZED_DIR="/scratch/09196/reneem/ChromHMM_DXR/Binarized_files"
CELLMARK_FILE="/scratch/09196/reneem/ChromHMM_DXR/cellmarkfile.txt"
CHROMSIZES="/scratch/09196/reneem/ChromHMM_DXR/hg38.chrom.sizes"


STATES_LIST=(16)

for NUM_STATES in "${STATES_LIST[@]}"; do

	MODEL_OUTPUT_DIR="/scratch/09196/reneem/ChromHMM_DXR/Chrom_model_${NUM_STATES}states_final"
	mkdir -p "$MODEL_OUTPUT_DIR"
	echo "Running ChromHMM with $NUM_STATES states..."

	java -Djava.awt.headless=true -Xmx60G -jar "$CHROMHMM" LearnModel -s 123 -p 8 -r 1000 -printposterior "$BINARIZED_DIR" "$MODEL_OUTPUT_DIR" $NUM_STATES $CHROMSIZES > "$MODEL_OUTPUT_DIR/more_log.txt" 2>&1
done

END=$(date)

echo "Script started at $START and ended at $END"
