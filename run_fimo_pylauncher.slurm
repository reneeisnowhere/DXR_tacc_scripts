#!/bin/bash
#SBATCH -J fimo_py
#SBATCH -o fimo_py.%j
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p normal
#SBATCH -t 01:10:00

module load tacc-apptainer
module load python3
module load pylauncher

cd /scratch/09196/reneem/memesuite
python3 -c "import pylauncher; print('ok')"
echo $(date) "Starting pylauncher FIMO run"

python  /scratch/09196/reneem/memesuite/scripts/launch_fimo.py

echo $(date) "Finished"
