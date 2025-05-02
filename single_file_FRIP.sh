#!/bin/bash
e#xec > >(tee -a frip_script.log) 2>&1

# Check for filename argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <BAM_filename>"
    exit 1
fi

FILENAME="$1"

echo "Loading modules"
module unload xalt
SAMTOOLS_CONTAINER="/scratch/09196/reneem/5FU/samtools_1.9--h91753b0_5.sif"
module load tacc-apptainer
module load biocontainers
module load bedtools

cd /scratch/09196/reneem/5FU/Frip_files

BASE_DIR="/scratch/09196/reneem/5FU/bam_folder/final_bam_folder"
BAM_BASENAME="${FILENAME%%.bam}"  # Remove .bam extension
OUTPUT="${BAM_BASENAME}_frip_detailed_results.tsv"


# Write header only if file doesn't exist
if [ ! -f "$OUTPUT" ]; then
    echo -e "Histone\tSample\tCall_type\tTotal_Reads\tMapped_Reads\tFragments\tReads_in_Peaks\tFRiP" > "$OUTPUT"
fi

HISTONE="H3K27me3"
HISTONE_DIR="${BASE_DIR}/${HISTONE}"
BAM_DIR="${HISTONE_DIR}"
PEAK_DIR="${HISTONE_DIR}/macs2_nolambda_nomodel_1e5"


BAM="${BAM_DIR}/${FILENAME}"

# Check if BAM file exists
if [[ ! -f "$BAM" ]]; then
    echo "BAM file not found: $BAM"
    exit 1
fi

BASENAME=$(basename "$BAM" _final.bam)

# Find matching peak file
PEAK_FILE=$(find "$PEAK_DIR" -maxdepth 1 -type f \( -name "${BASENAME}_peaks.narrowPeak" -o -name "${BASENAME}_peaks.broadPeak" \) | head -n 1)

if [[ -f "$PEAK_FILE" ]]; then
    echo " [$HISTONE] Processing $BASENAME..."

    TOTAL_READS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c "$BAM")
    MAPPED_READS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c -F 0x4 "$BAM")
    FRAGMENTS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c -f 0x2 "$BAM")
    READS_IN_PEAKS=$(bedtools intersect -a "$BAM" -b "$PEAK_FILE" -bed | wc -l)
    FRIP=$(echo "scale=4; $READS_IN_PEAKS / $MAPPED_READS" | bc)

	CALL_TYPE=$(basename "$PEAK_DIR")  # extracts 'peak anme'
echo -e "${HISTONE}\t${BASENAME}\t${CALL_TYPE}\t${TOTAL_READS}\t${MAPPED_READS}\t${FRAGMENTS}\t${READS_IN_PEAKS}\t${FRIP}" >> "$OUTPUT"
else
    echo "  [$HISTONE] Peak file missing for $BASENAME"
fi

