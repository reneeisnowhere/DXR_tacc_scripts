#!/bin/bash

#SBATCH -J Macs2_call	  	# Job name
#SBATCH -o 36me3.%j		# Name of stdout output file (%j expantds to jobID)
#SBATCH -p vm-small		# Queue name
#SBATCH -N 1			# Total number of nodes requested
#SBATCH -n 1 			# Total number of mpi tasks requested (normally 1)
#SBATCH -t 03:00:00		# Run time (hh:mm:ss)

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
module load bedtools
ST_SIF="$MYSCRATCH/5FU/samtools_1.9--h91753b0_5.sif"

cd /scratch/09196/reneem/5FU/bam_folder/final_bam_folder/H3K36me3

mkdir -p macs2_nolambda_nomodel_1e5
#mkdir -p macs2_nolambda_1e5
#mkdir -p macs2_llocal20k_q05
#mkdir -p macs2_llocal20k_q01
#mkdir -p macs2_nolambda_bcq05
#mkdir -p macs2_nolambda_bcq01

BLACKLIST="/scratch/09196/reneem/GRCh38/blacklist/hg38-blacklist.v2.bed"

echo $(date) "Starting macs2"
while IFS= read -r filename; do
        base_name="${filename%_final.bam}";
        input_bam="$filename";
        if [[ -f "$input_bam" ]]; then
                echo "Processing $filename";
                ###Remove blacklist regions
                filtered_bam="${base_name}_noblacklist.bam"
                sorted_bam="${base_name}_noblacklist_sorted.bam"
                echo "Filtering Blacklist regions"
                bedtools intersect -v -abam "$input_bam" -b "$BLACKLIST" > "$filtered_bam"
                apptainer exec "$ST_SIF" samtools sort -o "$sorted_bam" "$filtered_bam"
                apptainer exec "$ST_SIF" samtools index "$sorted_bam"
        ##no lambda
        macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --nolambda --nomodel -t "$sorted_bam" -q 1e-5 -n $base_name --outdir macs2_nolambda_nomodel_1e5 ;
        #macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --nolambda -t "$sorted_bam"  --broad-cutoff 0.1 -q 1e-5 -n $base_name --outdir macs2_nolambda_1e5 ;
        ###--local 20000 settings
       # macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --llocal 20000 -t "$sorted_bam"  -q 0.05 -n $base_name --outdir macs2_llocal20k_q05 ;
       # macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --llocal 20000 -t "$sorted_bam"  -q 0.01 -n $base_name --outdir macs2_llocal20k_q01 ;
        ## checking out nolambda and bc at same level
        #macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --nolambda -t "$sorted_bam" --broad-cutoff 0.01  -q 0.01 -n $base_name --outdir macs2_nolambda_bcq01 ;
        #macs2 callpeak -f BAMPE -g hs --keep-dup all --broad --nolambda -t "$sorted_bam" --broad-cutoff 0.05  -q 0.05 -n $base_name --outdir macs2_nolambda_bcq05 ;
	rm -f "$sorted_bam" "$sorted_bam.bai"

        echo "End of $filename";
else
        echo "warning: $input_bam not found, Skipping";
fi;
done < name_file_noM.txt



echo $(date) "All Done"


