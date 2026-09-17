#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=17:00:00
#SBATCH --mem=2G
#SBATCH --ntasks=2
#SBATCH --account=amc-general
#SBATCH --job-name=tarballer
#SBATCH --output=./output_logs/tarballer_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

out_gz="$1.md5"

tar -cvzf $1 $2 && md5sum $1 > $out_gz
