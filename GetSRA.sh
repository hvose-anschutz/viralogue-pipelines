#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=00:15:00
#SBATCH --mem=2G
#SBATCH --ntasks=2
#SBATCH --account=amc-general
#SBATCH --job-name=SRADump
#SBATCH --output=SRADump_Sidd_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --array=1-9

echo "Loading Apps:"
module load sra-toolkit/3.0.0
module load perl

echo "Current Array Task" ${SLURM_ARRAY_TASK_ID[@]}


perl /scratch/alpine/hvose@xsede.org/GetIFNAR_RNASeq.pl /projects/hvose@xsede.org/AccessionLists/PRJNA892984_Acc_List.txt $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT

