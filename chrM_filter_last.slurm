#!/bin/bash

#SBATCH -J chrM_filter	  	# Job name
#SBATCH -o filter55-94.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p vm-small		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 02:00:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem/
MYWORK=/work/09196/reneem/ls6/

 echo "Loading modules"
module unload xalt
 # Define container path
SAMTOOLS_CONTAINER="/scratch/09196/reneem/5FU/samtools_1.9--h91753b0_5.sif"
module load tacc-apptainer
module load biocontainers
#module load gatk
#module load samtools

# create scratch directory for this job
# and also work directory for its output
cd /scratch/09196/reneem/5FU

base_dir="/scratch/09196/reneem/5FU"
final_bam_folder="${base_dir}/bam_folder/final_bam_folder"

echo $(date) "Starting the metric things"
bam_folders=("H3K27ac" "H3K27me3" "H3K9me3" "H3K36me3")

	sed -n '55,94p' samplesheet.txt| while read -r i; do 
	echo $i;
	echo "filtering out chrM and others";
	
	for histone in "${bam_folders[@]}"; do
		subdir="${final_bam_folder}/${histone}"
		if [[ -d "$subdir" ]]; then
			
		final_bam="${subdir}/${i}_final.bam"
		noM_bam="${subdir}/${i}_noM_final.bam"

		if [[ -f "$final_bam" ]]; then
			echo "filtering BAM: $final_bam -> $noM_bam";
			apptainer exec ${SAMTOOLS_CONTAINER} samtools view -b "$final_bam" -o "$noM_bam" -L allowed_chroms.bed;
			apptainer exec ${SAMTOOLS_CONTAINER} samtools view -F 0x04 "$noM_bam" | awk -F'\t' 'function abs(x){return ((x< 0.0) ? -x : x)} {print abs($9)}' |sort|uniq -c| sort -b -k2,2n |awk -v OFS="\t" '{print $2, $1/2}' > metric_files/${i}_frag_len_noM.txt;
			echo "indexing final bam file";
			apptainer exec ${SAMTOOLS_CONTAINER} samtools index "$noM_bam";
		else 
			echo "BAM file not found: $final_bam";
		fi;
	else
		echo "Histone subdir not found: $subdir"
	fi
done

done


echo $(date) "All Done"


