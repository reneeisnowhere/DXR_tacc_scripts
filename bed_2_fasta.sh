mkdir -p fasta  # make sure output folder exists

#for bedfile in bed_files/{DOX,DNR,EPI,MTX}*20kb_centered.bed; do
for bedfile in bed_files/*.bed; do 
## check if any matching files exist
  [ -e "$bedfile" ] || continue

  filename=$(basename "$bedfile" .bed)
  
  # strip .bed extension to get base name
  basename="${bedfile%.bed}"
  
  # run bed2fasta using apptainer
  apptainer exec memesuite_latest.sif bed2fasta -s -both -o "fa_files/${filename}.fa" "$bedfile" fasta_human/UCSCMammal/hg38.fa
done

