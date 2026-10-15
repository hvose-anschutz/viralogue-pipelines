#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=02:30:00
#SBATCH --mem=36G
#SBATCH --ntasks=6
#SBATCH --account=amc-general
#SBATCH --job-name=MakeGeneCountMatrix
#SBATCH --output=data/MakeGeneCountMatrix_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load perl
module load homer/4.11

analyzeRepeats.pl /projects/hvose@xsede.org/hg38_RE_full_refs.txt hg38 -noadj -d \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/Clone_11_ART_S40_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/Clone_11_notreat_S37_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/Clone_18_ART_S41_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/Clone_18_notreat_S38_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/Lucia_ART_S39_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/Lucia_notreat_S36_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/WT_1_S33_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/WT_2_S34_L005/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/WT_3_S35_L005/ \
> countTableDRIPc_repeats.txt && \
python3 countTableAnnotator.py countTableDRIPc_repeats.txt /projects/hvose@xsede.org/hg38_RE_full_refs.txt countTable_DRIPc_annotated.txt 6