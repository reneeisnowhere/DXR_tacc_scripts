#!/bin/bash

#SBATCH -J bam_to_bw
#SBATCH -o make_bw.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 04:00:00


cd /scratch/09196/reneem/ChromHMM_DXR/scripts

module load tacc-apptainer

bash run_bamcoverage.sh

