#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=01:30:00
#SBATCH --mem=2G
#SBATCH --ntasks=2
#SBATCH --account=amc-general
#SBATCH --job-name=MakeGeneCountMatrixIntrons
#SBATCH --output=MakeGeneCountMatrixIntrons_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load perl
module load homer/4.11

analyzeRepeats.pl /projects/hvose@xsede.org/Mmus38_ERV.gtf mm10 -count introns -noadj -d \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/10_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/11_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/12_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/13_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/14_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/15_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/16_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/17_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/18_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/19_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/1_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/20_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/21_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/22_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/23_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/24_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/25_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/26_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/27_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/28_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/29_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/2_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/30_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/31_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/32_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/3_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/4_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/5_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/6_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/7_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/8_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/9_R1_001/ \
> countTableLocus_ecDNAintrons.txt

analyzeRepeats.pl /projects/hvose@xsede.org/Mmus38_ERV.gtf mm10 -count introns -noadj -d \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/10_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/11_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/12_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/13_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/14_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/15_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/16_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/17_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/18_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/19_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/1_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/20_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/21_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/22_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/23_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/24_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/25_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/26_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/27_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/28_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/29_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/2_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/30_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/31_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/32_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/3_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/4_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/5_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/6_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/7_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/8_R1_001/ \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/9_R1_001/ \
> countTableClass_ecDNAintrons.txt