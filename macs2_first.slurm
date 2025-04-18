#!/bin/bash

#SBATCH -J Macs2_call	  	# Job name
#SBATCH -o 27me3.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p vm-small		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 06:00:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem/
MYWORK=/work/09196/reneem/ls6/

 echo "Loading modules"
module unload xalt
 # Define container path
#BOWTIE2_CONTAINER="/scratch/09196/reneem/bowtie2.sif"

module load tacc-apptainer
module load biocontainers/
module load macs2


# create scratch directory for this job
# and also work directory for its output
cd /scratch/09196/reneem/5FU/bam_folder/final_bam_folder/H3K27me3

mkdir -p macs2_peak_q05
mkdir -p macs2_peak_q01
mkdir -p macs2_peak_q005

echo $(date) "Starting macs2"
while IFS= read -r filename; do 
	base_name="${filename%_final.bam}"; 
	input_bam="$filename"; if [[ -f "$input_bam" ]]; 
then 
	echo "Processing $filename";
        macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --broad-cutoff 0.1 -q 0.05  -t "$input_bam" -n $base_name --outdir macs2_peak_q05 ;
	macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --broad-cutoff 0.1 -q 0.01 -t "$input_bam" -n $base_name --outdir macs2_peak_q01 ;
	macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --broad-cutoff 0.1 -q 0.005 -t "$input_bam" -n $base_name --outdir macs2_peak_q005 ; 
	echo 
	"End of $filename";
else 
	echo 
	"warning: $input_bam not found, Skipping";
fi; 
done < name_file_noM.txt
	
echo $(date) "All Done"


