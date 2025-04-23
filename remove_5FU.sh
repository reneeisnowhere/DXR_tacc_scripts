#!/bin/bash

# Set paths
sample_info="new_clean_name.txt"  # your input file
base_dir="/scratch/09196/reneem/5FU/bam_folder/final_bam_folder"  # replace with actual path

# Skip header and process each line
tail -n +2 "$sample_info" | while IFS=$'\t' read -r library_ID histone_mark sample_ID ind_ID ind trt time other_time name; do
    if [[ "$trt" == "5FU" ]]; then
	     dir_path="$base_dir/${histone_mark}"
        file_pattern="${library_ID}*"  # Match any file that starts with Library_ID

        # Debugging output to check which files are being checked
        echo "Checking for files in: $dir_path"
        echo "Looking for files matching: $file_pattern"

        # Loop through the matching files in the histone mark directory
        for file in "$dir_path"/$file_pattern; do
            if [[ -f "$file" ]]; then
                echo "$(date) - Removing $file"
                rm "$file"
            else
                echo "$(date) - File not found: $file"
            fi
        done
    fi

    echo "$(date)"
done

