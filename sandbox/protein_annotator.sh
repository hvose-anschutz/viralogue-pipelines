#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=05:00:00
#SBATCH --mem=500M
#SBATCH --ntasks=1
#SBATCH --account=amc-general
#SBATCH --job-name=ProteinAnnotator
#SBATCH --array=1-10
#SBATCH --output=/scratch/alpine/hvose@xsede.org/Outputs/ProteinAnnotator_%J.out
#SBATCH --error=/scratch/alpine/hvose@xsede.org/Outputs/ProteinAnnotator_%J.err
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load python

python3 array_annotator.py $SLURM_ARRAY_TASK_ID