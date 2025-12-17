#!/bin/bash



#SBATCH -J DXR_script_backup           # Job name
#SBATCH -o DXR_backup_Run.%j             # Name of stdout output file (%j expantds to jobID)
#SBATCH -p vm-small          # Queue name
#SBATCH -N 1                    # Total number of nodes requested
#SBATCH -n 1                    # Total number of mpi tasks requested (normally 1)
#SBATCH -t 01:15:00             # Run time (hh:mm:ss)

# Define source and destination
SRC_DIRS=("/scratch/09196/reneem/5FU" "/work/09196/reneem/ls6/5FU" "/scratch/09196/reneem/ChromHMM_DXR" "/scratch/09196/reneem/DXR_meme")
DEST_DIR=~/DXR_tacc_scripts

# Create destination if it doesn't exist
mkdir -p "$DEST_DIR"

# Copy only .sh and .slurm files, preserving directory structure (but flattening is also possible)
for SRC in "${SRC_DIRS[@]}"; do
    find "$SRC" -type f \( -name "*.sh" -o -name "*.slurm" \) -exec cp --update {} "$DEST_DIR" \;
done

# Go to repo and commit changes
cd "$DEST_DIR" || exit
git add *.sh *.slurm

# Commit only if there are changes
if ! git diff --cached --quiet; then
    git commit -m "Automated backup of updated scripts from scratch and work"
    git push
else
    echo "No changes to commit."
fi

