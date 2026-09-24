#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH --ntasks=8
#SBATCH --account=amc-general
#SBATCH --job-name=pipeline_rework
#SBATCH --output=./data/pipeline_rework_%J.out
#SBATCH --array=1-15
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load sra-toolkit
module load biobloom

python3 pipeline_rework.py benchmarking_set.txt $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT $SLURM_NTASKS /projects/$USER/bloom_references/candida_albicans_SC5314.bf