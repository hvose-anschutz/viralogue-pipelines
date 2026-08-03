#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
#SBATCH --time=03:30:00
#SBATCH --mem=12G
#SBATCH --ntasks=6
#SBATCH --account=amc-general
#SBATCH --job-name=MakeGeneCountMatrixmm10
#SBATCH --output=MakeGeneCountMatrixmm10_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load perl
module load homer/4.11

analyzeRepeats.pl rna mm10 -count introns -noadj -d \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_dHE_2_S6_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_dHE_3_S7_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_dHE_4_S8_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_dHE_5_S9_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_dHE \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_WT_2_S11_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_WT_3_S12_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_WT_4_S13_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_WT_5_S14_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/MHVY_WT \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/Uninfected_2_S2_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/Uninfected_3_S3_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/Uninfected_4_S4_L002_R1_001 \
/scratch/alpine/hvose@xsede.org/MHVY_dHE_tagdir/tagdir/TagDirectory/Uninfected \
> countTableLocus_bulkdHEintrons.txt
