#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=08:00:00
#SBATCH --mem=128G
#SBATCH --ntasks=32
#SBATCH --account=amc-general
#SBATCH --job-name=DiamondAlignSingle
#SBATCH -o /scratch/alpine/hvose@xsede.org/Outputs/DiamondAlign_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load diamond
diamond blastx --db /scratch/alpine/hvose@xsede.org/diamond_dbs/nr.dmnd -q /scratch/alpine/hvose@xsede.org/Assembly/1320/final.contigs.fa -p 32 -o /scratch/alpine/hvose@xsede.org/Outputs/1320.diamondx.nr --outfmt 6 --max-target-seqs 2