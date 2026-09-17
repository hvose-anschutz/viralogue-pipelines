#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=16:00:00
#SBATCH --mem=24G
#SBATCH --ntasks=20
#SBATCH --account=amc-general
#SBATCH --job-name=region_extractor
#SBATCH --output=./data/region_extractor.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load samtools
module load bedtools

bedtools getfasta -fi /projects/hvose@xsede.org/Genomes/hg38/hg38.fa -bed hg38_RE_L1_bed.bed -fo hg38_RE_L1_seqs.fa -nameOnly