#!/bin/bash

#SBATCH -J sort_to_bam	  	# Job name
#SBATCH -o sort2bam.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p normal		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 08:15:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem/
MYWORK=/work/09196/reneem/ls6/

 echo "Loading modules"
module unload xalt
 # Define container path
#BOWTIE2_CONTAINER="/scratch/09196/reneem/bowtie2.sif"

module load tacc-apptainer
module load biocontainers/
module load gatk


# create scratch directory for this job
# and also work directory for its output
cd /scratch/09196/reneem/5FU



echo $(date) "Starting the the sorting and conversion"

	sed -n '65,94p' samplesheet.txt| while read -r i;do echo $i;
	gatk SortSam -I sam_folder/${i}.sam -O bam_folder/${i}_sort.bam -SORT_ORDER coordinate;
	
	echo "End of ${i}"
done



echo $(date) "All Done"


