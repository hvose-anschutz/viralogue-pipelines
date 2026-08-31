#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=02:00:00
#SBATCH --mem=10G
#SBATCH --ntasks=2
#SBATCH --account=amc-general
#SBATCH --job-name=SRADump
#SBATCH --output=data/sradump/SRADump_Sidd_%J.txt
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --array=1-20

echo "Loading Apps:"
module load sra-toolkit/3.0.0
module load perl

echo "Current Array Task" ${SLURM_ARRAY_TASK_ID[@]}

perl /scratch/alpine/hvose@xsede.org/viralogue-pipelines/RNA-seq-pipeline/GetSRA.pl /projects/hvose@xsede.org/AccessionLists/mm_intestine_stragglers.txt $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT

