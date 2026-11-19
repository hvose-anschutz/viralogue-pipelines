#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-long
#SBATCH --partition=acpu
#SBATCH --time=48:00:00
#SBATCH --mem=48G
#SBATCH --ntasks=24
#SBATCH --account=amc-general
#SBATCH --job-name=neoformans_regular_test
#SBATCH --output=./data/neoformans_regular_%J.out
#SBATCH --array=1-200
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load sra-toolkit
module load biobloom

python3 bloom_hammer_prefetch.py /projects/hvose@xsede.org/AccessionLists/c_neoformans_srrs.txt \
$SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT $SLURM_NTASKS \
/projects/$USER/bloom_references/neoformans.bf /scratch/alpine/hvose@xsede.org/neoformans_out/