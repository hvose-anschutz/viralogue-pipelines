#!/usr/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --ntasks=1
#SBATCH --mem=20M
#SBATCH --time=10:00:00
#SBATCH --job-name=gzipper_Kasey
#SBATCH --output=gzipper.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

tar -zcvf KaseyMapping.gz /scratch/alpine/hvose@xsede.org/SamFilesK
