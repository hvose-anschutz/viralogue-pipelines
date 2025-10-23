### RNA-Seq Pipeline

This is the pipeline for bulk RNA-Sequencing analysis, following the steps outlined below:
- 1. File Acquisition (SRA-toolkit and fasterq-dump) -> GetSRA
  2. Genome Generation (STAR) -> genomeGenerate
  3. Read Alignment (STAR) -> AlignToGenome
  4. Tag Directory Generation (HOMER) -> MakeTagDirectory
  5. Count Matrix Generation (HOMER) -> MakeGeneCountMatrix
  6. Differential Expression Analysis (HOMER) -> generateDiffExpression

  Each shell script is meant to be run on a SLURM-based HPC. Scripts may be run individually if desired.

  # More documentation coming soon
