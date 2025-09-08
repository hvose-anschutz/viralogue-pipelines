#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=04:00:00
#SBATCH --mem=80G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --job-name=GenerateGenome
#SBATCH --output=GenerateGenome_04212025_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load star
module load anaconda
conda activate rsem_install
module load perl

STAR --runMode genomeGenerate --runThreadN 12 --genomeDir /scratch/alpine/hvose@xsede.org/Genomes/Hsap/ --genomeFastaFiles /scratch/alpine/hvose@xsede.org/Genomes/Hsap/Hsap38.geve.ntm_v1.fa
