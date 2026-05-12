#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=01:00:00
#SBATCH --mem=52G
#SBATCH --ntasks=8
#SBATCH --account=amc-general
#SBATCH --job-name=gsea_ora_test
#SBATCH --output=gsea_ora_test_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load anaconda
conda activate jupyter_scrna

python3 gsea_ora.py