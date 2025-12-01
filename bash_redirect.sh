#!/bin/bash
set -e

BASE="/scratch/09196/reneem/ChromHMM_DXR/Binarized_files"

cd "$BASE"

echo "Reorganizing ChromHMM binarized files..."
echo "Working directory: $BASE"
echo

# Find all files that look like SAMPLE_chrX_binary.txt
files=$(ls *_chr*_binary.txt 2>/dev/null)

if [[ -z "$files" ]]; then
    echo "❌ No files matching *_chr*_binary.txt found."
    exit 1
fi

for file in $files; do
    # Extract sample name (before _chr...)
    sample=$(echo "$file" | sed -E 's/_chr[0-9XY]+_binary.txt//')

    # Extract chromosome (chr##, chrX, chrY)
    chr=$(echo "$file" | sed -E 's/.*_(chr[0-9XY]+)_binary.txt/\1/')

    # Make sample directory
    mkdir -p "$sample"

    # Destination
    dest="$sample/${chr}_binary.txt"

    echo "→ $file  -->  $dest"

    # Move file to sample folder
    mv "$file" "$dest"
done

echo
echo "✔ Done reorganizing!"
echo "✔ Your directory now contains one folder per sample with chr*_binary.txt files."
echo "You can now safely run ChromHMM LearnModel."

