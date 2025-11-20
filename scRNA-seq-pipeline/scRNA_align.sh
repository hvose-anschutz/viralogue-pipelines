#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=01:00:00
#SBATCH --mem=24G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --array=1-9
#SBATCH --job-name=AlignToGenome_scRNA
#SBATCH --output=AlignToGenome_scRNA_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

perl scRNA_align.pl all_R1_fastqs.txt /projects/hvose@xsede.org/Genomes/mhvy-mm10 /projects/hvose@xsede.org/barcodes/3M-3pgex-may-2023_TRU.txt $SLURM_TASK_ARRAY_ID $SLURM_ARRAY_TASK_COUNT