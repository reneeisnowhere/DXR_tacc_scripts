for f in /scratch/09196/reneem/memesuite/fa_files/chunk_*; do
base=$(basename $f)
echo "apptainer exec --bind /scratch/09196/reneem/memesuite/fa_files:/home/fasta,/scratch/09196/reneem/memesuite/fimo_results/H3K27ac_KZFP_fimo:/home/fimo_out /scratch/09196/reneem/memesuite/memesuite_latest.sif fimo --oc /home/fimo_out/${base} --thresh 1e-4 /scratch/09196/reneem/memesuite/motif_databases/KZFP_motifs.meme /home/fasta/${base}" >> fimo_commands.txt

done
