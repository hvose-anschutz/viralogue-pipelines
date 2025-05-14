#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=01:00:00
#SBATCH --mem=24G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --array=1-9
#SBATCH --job-name=AlignToGenome
#SBATCH --output=AlignToGenome_Sidd_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load star/2.7.10b
module load perl

perl /scratch/alpine/$USER/Miner_Chauvin_AlignToGenome.pl /scratch/alpine/$USER/sra/PRJNA892984/ $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT PRJNA892984_FASTQ.txt
