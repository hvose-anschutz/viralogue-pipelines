#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=02:00:00
#SBATCH --mem=48G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --job-name=GenerateGenome
#SBATCH --output=GenerateGenome_new_auris_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load star
module load perl

STAR --runMode genomeGenerate --runThreadN 12 --genomeDir /projects/hvose@xsede.org/Genomes/c_auris_B8441/ --genomeFastaFiles /scratch/alpine/hvose@xsede.org/c_auris_genomes/B8441_genomic.fna
