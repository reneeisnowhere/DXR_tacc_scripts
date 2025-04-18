#!/bin/bash

#SBATCH -J cutadapt	  	# Job name
#SBATCH -o 4hrcutadapt.%j	# Name of stdout output file (%j expantds to jobID)
#SBATCH -p normal		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 05:00:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem
MYWORK=/work/09196/reneem/ls6/

module load cutadapt
module load tacc-apptainer
module load multiqc

echo $(date) "Start"

# create scratch directory for this job
# 
#mkdir -p /scratch/09196/5FU/cut_adapt_files/
cd /scratch/09196/reneem/5FU 

### Trim files
for i in $(tail -20 *samplesheet.txt); do cutadapt -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT -j 0 -m 1 -o cut_adapt_files/${i}_R1_trim.fastq.gz -p cut_adapt_files/${i}_R2_trim.fastq.gz fastq_files/${i}_R1.fastq.gz fastq_files/${i}_R2.fastq.gz; done


echo $(date) "Done with cut adapt"
## make output file for fastqc

#mkdir -p $MYSCRATCH/5FU/cut_adapt_files/output

echo "running the image file:"
apptainer exec fastqc_0.11.8.sif fastqc -t 12 -o /scratch/09196/reneem/5FU/cut_adapt_files/output/ /scratch/09196/reneem/5FU/cut_adapt_files/*.gz

echo "running multiqc"

cd /scratch/09196/reneem/5FU/cut_adapt_files/output

multiqc .

echo "all done"
#
# cp ../cmtox/run_1/results/* /work/09196/reneem/ls6/cmtox/run_1/results/
#
# echo "Hopefully all done"
#
