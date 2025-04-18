#!/bin/bash

#SBATCH -J test  	# Job name
#SBATCH -o test.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p vm-small 		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 00:20:00		# Run time (hh:mm:ss)

# create variables for scratch and work directories
MYSCRATCH=/scratch/09196/reneem/
MYWORK=/work/09196/reneem/ls6/

echo "Loading Bowtie2 module"
module load tacc-apptainer
module reset
module load biocontainers
#module load bowtie2/ctr-2.3.4.3--py37he860b03_1

apptainer pull --dir /scratch/09196/reneem/ bowtie2.sif docker://quay.io/biocontainers/bowtie2:2.5.4--he96a11b_5

#module list

#which bowtie2
# create scratch directory for this job
# and also work directory for its output
cd /scratch/09196/reneem/5FU
echo "finding .sif"
apptainer exec /scratch/09196/reneem/bowtie2.sif bowtie2 --version


echo $(date) "Starting the first alignment"

#	sed -n '65,66p' samplesheet.txt| while read -r i;do echo $i >> test_1.txt ;echo $i; bowtie2 -q --threads 16 --very-sensitive-local --no-mixed --no-discordant --phred33 -I 10 -X 700 -x /scratch/09196/reneem/GRCh38/bowtie2_index/GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index -1 cut_adapt_files/${i}_R1_trim.fastq.gz -2 cut_adapt_files/${i}_R2_trim.fastq.gz -S sam_folder/${i}.sam 2>> test_1.txt;
#done



echo $(date) "Done"


