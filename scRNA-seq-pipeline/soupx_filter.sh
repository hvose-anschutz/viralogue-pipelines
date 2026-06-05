#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=06:00:00
#SBATCH --mem=50G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --job-name=soupx_filter_live
#SBATCH --output=soupx_filter_live_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load anaconda
conda activate jupyter_scrna

python3 soupx_filter.py