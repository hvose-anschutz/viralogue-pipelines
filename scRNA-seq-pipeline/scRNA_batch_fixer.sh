#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=02:00:00
#SBATCH --mem=150G
#SBATCH --ntasks=8
#SBATCH --account=amc-general
#SBATCH --job-name=batch_fixer
#SBATCH --output=batch_fixer_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load anaconda
conda activate jupyter_scrna

python3 scRNA_batch_fixer.py