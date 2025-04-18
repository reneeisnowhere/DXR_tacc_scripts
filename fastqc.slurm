#!/bin/bash

#SBATCH -J fastqc-5FU	  	# Job name
#SBATCH -o fastqc-5FU.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p development 		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 01:00:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem/
MYWORK=/work/09196/reneem/ls6/

module load fastqc
module load multiqc



cd $MYSCRATCH/5FU/fastq_files/


#mkdir -p $MYWORK/GRCh38
#cd $MYSCRATCH/GRCh38

# copy the script
#cp ~/download-genome.R .

# Download and index the genome
echo $(date) "Starting fastqct"
 
fastqc -o output/ -t 6 *.fastq.gz

#echo $(date) "Copying output files"
#cp -a $MYSCRATCH/GRCh38/* $MYWORK/GRCh38/

echo $(date) "multiqc"

cd output
multiqc .
echo $(date) "end"
# mkdir -p /scratch/09196/reneem/cmtox/run_1/results/
#
#
# echo "running the image file:"
# singularity run fastqc_0.11.8.sif fastqc -o /scratch/09196/reneem/cmtox/run_1/results/ ../cmtox/run_1/fastq.gz_files/*.gz
#
# echo "saving files"
#    
# cp ../cmtox/run_1/results/* /work/09196/reneem/ls6/cmtox/run_1/results/
#
# echo "Hopefully all done"
#
