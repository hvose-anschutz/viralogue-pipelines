#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=00:45:00
#SBATCH --mem=24G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --job-name=bloom_sickle_prefetch
#SBATCH --output=./data/bloom_sickle_prefetch_%J.out
#SBATCH --array=1-10
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load sra-toolkit
module load star
module load biobloom

python3 bloom_sickle_prefetch.py /projects/hvose@xsede.org/AccessionLists/c_neoformans_10_test.txt \
$SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT $SLURM_NTASKS \
/projects/$USER/bloom_references/neoformans.bf /projects/hvose@xsede.org/Genomes/c_neoformans/ /scratch/alpine/hvose@xsede.org/neoformans_sickle_test/