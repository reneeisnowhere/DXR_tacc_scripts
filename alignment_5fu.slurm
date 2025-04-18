#!/bin/bash

#SBATCH -J alignment	  	# Job name
#SBATCH -o alignmentredo.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p normal 		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 05:20:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem/
MYWORK=/work/09196/reneem/ls6/

 echo "Loading Bowtie2 module"
 # Define container path
BOWTIE2_CONTAINER="/scratch/09196/reneem/bowtie2.sif"

module load tacc-apptainer
module load biocontainers
#module load samtools
#module load bowtie2/ctr-2.3.4.1--py35h2d50403_1

# create scratch directory for this job
# and also work directory for its output
cd /scratch/09196/reneem/5FU



echo $(date) "Starting the first alignment"

	sed -n '1,36p' samplesheet.txt| while read -r i;do echo $i >> test_output.txt ;echo $i; apptainer exec $BOWTIE2_CONTAINER bowtie2 -q --threads 12 --very-sensitive-local --no-mixed --no-discordant --phred33 -I 10 -X 700 -x /scratch/09196/reneem/GRCh38/bowtie2_index/GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index -1 cut_adapt_files/${i}_R1_trim.fastq.gz -2 cut_adapt_files/${i}_R2_trim.fastq.gz -S sam_folder/${i}.sam 2>> test_output.txt;
done



echo $(date) "Done"


