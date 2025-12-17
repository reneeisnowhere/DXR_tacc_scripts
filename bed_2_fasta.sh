mkdir -p fasta  # make sure output folder exists

for bedfile in bed_files/*.bed; do
  ## check if any matching files exist
  [ -e "$bedfile" ] || continue

  filename=$(basename "$bedfile" .bed)
  
  # strip .bed extension to get base name
  basename="${bedfile%.bed}"
  
  # run bed2fasta using apptainer
  apptainer exec memesuite_5.5.9.sif bed2fasta -s -both -o "fasta/${filename}.fa" "$bedfile" UCSCMammal/hg38.fna
done

