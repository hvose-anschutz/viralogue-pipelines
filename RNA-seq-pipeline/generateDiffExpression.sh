#!/bin/sh

#SBATCH --nodes=1
#SBATCH --qos=cpu-normal
#SBATCH --partition=acpu
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

getDiffExpression.pl countTableLocus_bulkdHE.txt dHE dHE dHE dHE dHE WT WT WT WT WT Ctl Ctl Ctl Ctl \
-repeats -AvsA -DESeq2 -simpleNorm > DiffExpressionLocus_dHE_SimpleNorm.txt ;
