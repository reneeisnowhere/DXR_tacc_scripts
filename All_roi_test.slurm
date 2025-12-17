#!/bin/bash

#SBATCH -J xstreme
#SBATCH -o All_roi.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 8:00:00

echo $(date) "Starting process"

ml tacc-apptainer

cd /scratch/09196/reneem/DXR_meme


apptainer exec --bind `pwd`:/home/meme memesuite_5.5.9.sif xstreme --oc All_ROI_run_xstreme/ --time 640 --streme-totallength 10000000 --meme-searchsize 100000 --desc description --dna --evt 0.05 --minw 6 --maxw 25 --align center --meme-p 8 --meme-mod zoops --m motif_databases/JASPAR/JASPAR2024_CORE_vertebrates_non-redundant_v2.meme  --p fasta/All_ROIs.fa 

echo $(date) "Running just on All_ROIs done"
