#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=02:00:00
#SBATCH --mem=6G
#SBATCH --ntasks=1
#SBATCH --account=amc-general
#SBATCH --array=1-36
#SBATCH --job-name=gunzipper_scRNA
#SBATCH --output=/scratch/alpine/hvose@xsede.org/Outputs/gunzipper_scRNA.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load perl

perl /scratch/alpine/$USER/Krishnamurthy_07152025_GEX/gunzipper.pl $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT /scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/all_gz.txt
