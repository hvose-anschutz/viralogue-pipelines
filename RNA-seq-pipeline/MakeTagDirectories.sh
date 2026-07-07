#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=01:30:00
#SBATCH --mem=24G
#SBATCH --ntasks=4
#SBATCH --array=1-75
#SBATCH --account=amc-general
#SBATCH --job-name=MakeTagDir
#SBATCH --output=MakeTagDirC_Sidd_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load homer
module load perl

perl /scratch/alpine/$USER/viralogue-pipelines/RNA-seq-pipeline/MakeTagDirectory_LocusSingle.pl /scratch/alpine/$USER/SamFiles/Locus/SamFilenames.txt $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT
