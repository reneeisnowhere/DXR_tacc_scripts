#!/bin/bash

#SBATCH -J testEAR
#SBATCH -o EARtest_hyper.%j
#SBATCH -p development
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 00:10:00

echo $(date) "Starting process"

ml tacc-apptainer


apptainer exec --bind `pwd`:/home/meme memesuite_latest.sif xstreme --oc ESR_A_xstreme_test/ --time 5 --streme-totallength 6000000 --meme-searchsize 50000 --desc description --dna --evt 0.05 --minw 6 --maxw 15 --align center --meme-mod zoops --m motif_databases/JASPAR/JASPAR2022_CORE_vertebrates_non-redundant_v2.meme  --p fasta/EAR_hyper.fa -n fasta/NR_df.fa

echo $(date) "test run done"
