#!/bin/bash

#SBATCH -J Frip_all	  	# Job name
#SBATCH -o Frip_all.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p normal		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 08:00:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
#MYSCRATCH=/scratch/09196/reneem/
#MYWORK=/work/09196/reneem/ls6/


exec > >(tee -a allrun_frip_script.log) 2>&1

echo $(date) "Loading modules"
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
OUTPUT="frip_llocal20k_nolambda_detailed_results.tsv"
echo -e "Histone\tSample\tTotal_Reads\tMapped_Reads\tFragments\tReads_in_Peaks\tFRiP" > "$OUTPUT"
HISTONES=("H3K27ac" "H3K27me3" "H3K36me3" "H3K9me3")
PEAK_SUBDIRS=("macs2_nolambda_q01" "macs2_nolambda_q05" "macs2_llocal20k_q01" "macs2_llocal20k_q05")
# Loop through each histone directory
for HISTONE in "${HISTONES[@]}"; do
        HISTONE_DIR="${BASE_DIR}/${HISTONE}"
        HISTONE=$(basename "$HISTONE_DIR")
        BAM_DIR="${HISTONE_DIR}"



    # Check if bam and peaks directories exist
    [[ ! -d "$BAM_DIR" ]] && continue

    for BAM in "$BAM_DIR"/*_noM_final.bam; do
        BASENAME=$(basename "$BAM" _final.bam)

	for SUBDIR in "${PEAK_SUBDIRS[@]}"; do 
		PEAK_DIR="${HISTONE_DIR}/${SUBDIR}"
		[[ ! -d "$PEAK_DIR" ]] && continue
		
		# Match either narrowPeak or broadPeak
 	      	for PEAK_FILE in "$PEAK_DIR/${BASENAME}_peaks.narrowPeak" "$PEAK_DIR/${BASENAME}_peaks.broadPeak"; do
		       if [[ -f "$PEAK_FILE" ]]; then
			       echo " [$HISTONE | $SUBDIR]  Processing $BASENAME..."

        		    TOTAL_READS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c "$BAM") 
			    MAPPED_READS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c -F 0x4 "$BAM") 
			    FRAGMENTS=$(apptainer exec "$SAMTOOLS_CONTAINER" samtools view -c -f 0x2 "$BAM")
			    READS_IN_PEAKS=$(bedtools intersect -a "$BAM" -b "$PEAK_FILE" -bed | wc -l)
		 	    FRIP=$(echo "scale=4; $READS_IN_PEAKS / $MAPPED_READS" | bc)

		    	    echo -e "${HISTONE}\t${BASENAME}\t${SUBDIR}\t${TOTAL_READS}\t${MAPPED_READS}\t${FRAGMENTS}\t${READS_IN_PEAKS}\t${FRIP}" >> "$OUTPUT"
		    		## Stop after processing one Bam Fil in each subdir
		    #	break
		    
    		else
		    echo "  [$HISTONE] Peak file missing for $BASENAME"
    	    fi
   done
   done
  # break
   done

done

echo $(date) "All Done"
