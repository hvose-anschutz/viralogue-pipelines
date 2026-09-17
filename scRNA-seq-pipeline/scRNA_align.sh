#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=07:00:00
#SBATCH --mem=64G
#SBATCH --ntasks=12
#SBATCH --account=amc-general
#SBATCH --array=1-6
#SBATCH --job-name=AlignToGenome_scRNA
#SBATCH --output=AlignToGenome_scRNA_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load perl
module load star/2.7.10b

perl scRNA_align.pl all_R1_fastqs.txt /projects/hvose@xsede.org/Genomes/mhvy_mm10 /projects/hvose@xsede.org/barcodes/3M_3pgex_may_2023_TRU.txt $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_COUNT
