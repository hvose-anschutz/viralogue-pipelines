#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=16:00:00
#SBATCH --mem=66G
#SBATCH --ntasks=20
#SBATCH --account=amc-general
#SBATCH --array=1-13
#SBATCH --job-name=AlignAndTag
#SBATCH --output=./data/AlignAndTag_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load star/2.7.10b
module load homer
module load perl

perl /scratch/alpine/hvose@xsede.org/viralogue-pipelines/RNA-seq-pipeline/AlignAndTag.pl /scratch/alpine/$USER/sra/ $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT /scratch/alpine/hvose@xsede.org/sra/all_thp1_single_fastq.txt