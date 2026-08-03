#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=01:00:00
#SBATCH --mem=48G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --array=1-75
#SBATCH --job-name=AlignToGenome
#SBATCH --output=AlignToGenome_Sidd_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load star/2.7.10b
module load perl

perl /scratch/alpine/hvose@xsede.org/viralogue-pipelines/RNA-seq-pipeline/AlignToGenome.pl /scratch/alpine/$USER/sra/ $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT /scratch/alpine/hvose@xsede.org/sra/PRJNA818339_FASTQS.txt
