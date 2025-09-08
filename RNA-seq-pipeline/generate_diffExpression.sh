#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --time=00:30:00
#SBATCH --mem=10G
#SBATCH --ntasks=2
#SBATCH --account=amc-general
#SBATCH --job-name=DiffExpression
#SBATCH --output=DiffExpression_Sidd_%J.out
#SBATCH --mail-user=holly.vose@cuanschutz.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

echo "Loading Apps:"
module load deseq2/1.46.0
module load perl
module load homer

getDiffExpression.pl /scratch/alpine/$USER/countTableLocus_PRJNA892984.txt Control Control Control Amp Amp Amp AmpTrib AmpTrib AmpTrib \
-repeats -AvsA -DESeq2 -simpleNorm > DiffExpressionLocus_PRJNA_892984_SimpleNorm.txt ;

getDiffExpression.pl /scratch/alpine/$USER/countTableClass_PRJNA892984.txt Control Control Control Amp Amp Amp AmpTrib AmpTrib AmpTrib \
-repeats -AvsA -DESeq2 -simpleNorm > DiffExpressionClass_PRJNA_892984_SimpleNorm.txt ;
