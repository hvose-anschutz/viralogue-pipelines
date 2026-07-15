#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=12:00:00
#SBATCH --mem=72G
#SBATCH --ntasks=20
#SBATCH --account=amc-general
#SBATCH --array=1-32
#SBATCH --job-name=AlignAndTag
#SBATCH --output=./data/AlignAndTag_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load star/2.7.10b
module load homer
module load perl

perl /scratch/alpine/hvose@xsede.org/viralogue-pipelines/RNA-seq-pipeline/AlignAndTag.pl /scratch/alpine/$USER/30-1340296303/00_fastq/ $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT /scratch/alpine/hvose@xsede.org/30-1340296303/00_fastq/all_jminer_R1.txt