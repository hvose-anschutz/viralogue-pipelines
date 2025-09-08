#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH --ntasks=2
#SBATCH --account=amc-general
#SBATCH --job-name=MakeGeneCountMatrix
#SBATCH --output=MakeGeneCountMatrixLCSidd_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

module load perl
module load homer/4.11

analyzeRepeats.pl rna mm10 -noadj -d \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006723 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006730 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006731 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006724 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006725 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006726 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006727 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006728 \
/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/SRR22006729 \
> countTableClass_PRJNA892984.txt

analyzeRepeats.pl rna mm10 -noadj -d \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006723 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006730 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006731 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006724 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006725 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006726 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006727 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006728 \
/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/SRR22006729 \
> countTableLocus_PRJNA892984.txt
