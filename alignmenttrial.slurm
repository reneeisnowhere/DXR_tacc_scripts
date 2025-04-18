#!/bin/bash

#SBATCH -J test-map	  	# Job name
#SBATCH -o ind1_bowtie2.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p normal 		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 04:00:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem/
MYWORK=/work/09196/reneem/ls6/

# echo "Loading singularity"
# module load tacc-singularity

module load bowtie2/ctr-2.3.4.1--py35h2d50403_1

# create scratch directory for this job
# and also work directory for its output
cd $MYSCRATCH/cmtox/atac_runs/ind1/trimmed/
#mkdir -p $MYSCRATCH/cmtox/atac-runs/ind1/trimmed/

#mkdir -p $MYWORK/GRCh38
#cd $MYSCRATCH/GRCh38

# copy the script
#cp ~/download-genome.R .

# Download and index the genome
echo $(date) "Starting the first test"
 
for i in $(cat trimmed_samplesheet.txt) ; 
  do bowtie2 -q --threads 16 --very-sensitive-local -x /scratch/09196/reneem/GRCh38/bowtie2_index/GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index -1 ${i}_R1.fastq.gz -2 ${i}_R2.fastq.gz -S ${i}.sam ;
done

#echo $(date) "Copying output files"
#cp -a $MYSCRATCH/GRCh38/* $MYWORK/GRCh38/

echo $(date) "Done"

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
