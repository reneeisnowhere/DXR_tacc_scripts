#!/bin/bash

##Source directory
SRC_BASE="/work/10819/styu/MW_multiQC/peaks"


### DEstination directory

DEST_BASE="/scratch/09196/reneem/5FU/summit_files"

#make sure dir exists

mkdir -p "$DEST_BASE"

## Histone list
HISTONES=("H3K27ac" "H3K27me3" "H3K36me3" "H3K9me3")

### Loop through files

for histone in "${HISTONES[@]}"; do
	##Finding all matching files
	find "$SRC_BASE/$histone" -type f -name "MCW*_FINAL_summits.bed" | while read -r file; do
	relpath="${file#$SRC_BASE/}"
	##Construct destination path
	dest="$DEST_BASE/$relpath"
	## Create destination directory
	mkdir -p "$(dirname "$dest")"
	#Copy file
	cp "$file" "$dest"
	echo "Copied $file -> $dest"
	done
done
