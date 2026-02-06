#!/bin/bash

#SBATCH -J xstreme
#SBATCH -o set32set1.%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 8:00:00

echo $(date) "Starting process"

ml tacc-apptainer

cd /scratch/09196/reneem/DXR_meme


apptainer exec --bind `pwd`:/home/meme memesuite_5.5.9.sif xstreme --oc H3K36me3/H3K36me3_set2_400/ --time 640 --streme-totallength 10000000 --meme-searchsize 100000 --desc description --dna --evt 0.05 --minw 6 --maxw 25 --align center --meme-p 8 --meme-mod zoops --m motif_databases/JASPAR/JASPAR2024_CORE_vertebrates_non-redundant_v2.meme  --p fasta/H3K36me3_Set_2_400.fa  --n fasta/H3K36me3_Set_1_400.fa

echo $(date) "Running just on  Set2vset1 400 done"
