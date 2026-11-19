#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=16:00:00
#SBATCH --mem=8G
#SBATCH --ntasks=8
#SBATCH --account=amc-general
#SBATCH --job-name=star_rarefaction_test
#SBATCH --output=./data/tolli_auris_rarefaction_%J.out
#SBATCH --array=1-2
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load sra-toolkit
module load star
module load biobloom

python3 bloom_rarefaction_STAR_test.py /projects/hvose@xsede.org/AccessionLists/tolli_auris_rarefaction.txt \
$SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT $SLURM_NTASKS \
/projects/$USER/bloom_references/C_auris_B8441.bf /projects/hvose@xsede.org/Genomes/c_auris_B8441/ /scratch/alpine/hvose@xsede.org/rarefaction_test/