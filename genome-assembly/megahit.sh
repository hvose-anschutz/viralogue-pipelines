#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=20:00:00
#SBATCH --mem=128G
#SBATCH --ntasks=24
#SBATCH --array=1-32
#SBATCH --account=amc-general
#SBATCH --job-name=megahit_assembly
#SBATCH --output=megahit_assembly_%J.out
#SBATCH --error=megahit_assembly_%J.err
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load anaconda
module load perl
conda activate viral_pipeline

perl megahit_per_sample.pl ecDNA_R1.txt $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT
