#!/bin/bash

#SBATCH -J Frip_q05	  	# Job name
#SBATCH -o Frip_calc.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p vm-small		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 02:00:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
#MYSCRATCH=/scratch/09196/reneem/
#MYWORK=/work/09196/reneem/ls6/


exec > >(tee -a frip_script.log) 2>&1

 echo "Loading modules"
module unload xalt
 # Define container path
SAMTOOLS_CONTAINER="/scratch/09196/reneem/5FU/samtools_1.9--h91753b0_5.sif"
module load tacc-apptainer
module load biocontainers
module load bedtools
#module load samtools

# create scratch directory for this job
# and also work directory for its output
cd /scratch/09196/reneem/5FU/Frip_files

BASE_DIR="/scratch/09196/reneem/5FU/bam_folder/final_bam_folder"
OUTPUT="frip_detailed_results.tsv"
echo -e "Histone\tSample\tTotal_Reads\tMapped_Reads\tFragments\tReads_in_Peaks\tFRiP" > "$OUTPUT"
HISTONES=("H3K27ac" "H3K27me3" "H3K36me3" "H3K9me3")
# Loop through each histone directory
for HISTONE in "${HISTONES[@]}"; do
        HISTONE_DIR="${BASE_DIR}/${HISTONE}"
        HISTONE=$(basename "$HISTONE_DIR")
        BAM_DIR="${HISTONE_DIR}"
        PEAK_DIR="${HISTONE_DIR}/macs2_peak_q05"

    # Check if bam and peaks directories exist
    [[ ! -d "$BAM_DIR" || ! -d "$PEAK_DIR" ]] && continue

    for BAM in "$BAM_DIR"/*_noM_final.bam; do
        BASENAME=$(basename "$BAM" _final.bam)

        # Match either narrowPeak or broadPeak
        PEAK_FILE=$(find "$PEAK_DIR" -maxdepth 1 -type f \( -name "${BASENAME}_peaks.narrowPeak" -o -name "${BASENAME}_peaks.broadPeak" \) | head -n 1)

        if [[ -f "$PEAK_FILE" ]]; then
            echo " [$HISTONE] Processing $BASENAME..."

            TOTAL_READS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c "$BAM")
            MAPPED_READS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c -F 0x4 "$BAM")
            FRAGMENTS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c -f 0x2 "$BAM")
            READS_IN_PEAKS=$(bedtools intersect -a "$BAM" -b "$PEAK_FILE" -bed | wc -l)
            FRIP=$(echo "scale=4; $READS_IN_PEAKS / $MAPPED_READS" | bc)

            echo -e "${HISTONE}\t${BASENAME}\t${TOTAL_READS}\t${MAPPED_READS}\t${FRAGMENTS}\t${READS_IN_PEAKS}\t${FRIP}" >> "$OUTPUT"
        else
            echo "  [$HISTONE] Peak file missing for $BASENAME"
        ##Stop after first file for testing
	    break
    	fi
    done
done

echo $(date) "All Done"


