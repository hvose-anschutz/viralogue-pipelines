#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=04:00:00
#SBATCH --mem=80G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --job-name=GenerateGenome
#SBATCH --output=GenerateGenome_new_mm10_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load star
module load anaconda
conda activate rsem_install
module load perl

STAR --runMode genomeGenerate --runThreadN 12 --genomeDir /projects/hvose@xsede.org/Genomes/mm10/ --genomeFastaFiles /projects/hvose@xsede.org/Genomes/mm10/mm10.fa
