#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=06:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=8
#SBATCH --account=amc-general
#SBATCH --job-name=raw_scrna_processor
#SBATCH --output=raw_scrna_processor_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load anaconda
conda activate jupyter_scrna

python3 raw_scrna_processor.py