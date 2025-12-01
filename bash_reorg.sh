#!/bin/bash
set -e

BASE="/scratch/09196/reneem/ChromHMM_DXR/Binarized_files"

cd "$BASE"

echo "Reversing previous ChromHMM binarized file reorganization..."
echo "Working directory: $BASE"
echo

# Loop over all subdirectories (sample folders)
for sample_dir in */ ; do
    # Skip if not a directory
    [[ -d "$sample_dir" ]] || continue

    sample_dir=${sample_dir%/}  # remove trailing /

    # Find all _binary.txt files inside this folder
    for file in "$sample_dir"/*_binary.txt; do
        # Skip if no files match
        [[ -f "$file" ]] || continue

        filename=$(basename "$file")
        new_name="${sample_dir}_${filename}"  # prefix with folder name

        echo "← Moving $file  -->  $BASE/$new_name"

        cp "$file" "$BASE/$new_name"
    done

    # Remove now-empty sample directory
    #rmdir "$sample_dir"
done
echo "✔ Done reversing reorganization!"

