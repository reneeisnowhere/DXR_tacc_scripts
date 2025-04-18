#!/bin/bash

#SBATCH -J extract_metric	  	# Job name
#SBATCH -o extract57-64.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p development		# Queue name
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


echo $(date) "Starting the metric things"

	sed -n '57,64p' samplesheet.txt| while read -r i; do echo $i;
	apptainer exec ${SAMTOOLS_CONTAINER} samtools flagstat bam_folder/${i}_sort.bam |tee metric_files/${i}_flagstat.txt;
	#apptainer exec ${SAMTOOLS_CONTAINER} samtools index bam_folder/${i}_sort.bam bam_folder/${i}_sort.bam.bai;
	#apptainer exec ${SAMTOOLS_CONTAINER} samtools idxstats bam_folder/${i}_sort.bam |tee metric_files/${i}_stats.txt;
	echo "pulling frag length";
	apptainer exec ${SAMTOOLS_CONTAINER} samtools view -F 0x04 bam_folder/${i}_sort.bam |awk -F'\t' 'function abs(x){return ((x< 0.0) ? -x : x)} {print abs($9)}' |sort| uniq -c| sort -b -k2,2n |awk -v OFS="\t" '{print $2, $1/2}'> metric_files/${i}_frag_len_count.txt;
	apptainer exec ${SAMTOOLS_CONTAINER} samtools view -F 260 -q 30 -b bam_folder/${i}_sort.bam > bam_folder/final_bam_folder/${i}_final.bam;
	echo "indexing ${i} final bam file";
	apptainer exec ${SAMTOOLS_CONTAINER} samtools index bam_folder/final_bam_folder/${i}_final.bam;
	echo "End of ${i} at $(date)";
	
done



echo $(date) "All Done"


