# SINGLE CELL RNA SEQUENCING ANALYSIS PIPELINE

The current scRNA sequencing analysis pipeline uses STARSolo to align FASTQ files
to a given reference genome. Once aligned, either `scrna_visual_analysis.ipynb`
or `raw_scrna_processor.py` can be used to process the data into a smaller,
space-friendly export file in h5ad format. Once processed, this file can be
loaded by `scrna_load_analysis.py` to generate visualizations, determine cell
clustering, and calculate gene differential expression comparisons across multiple
groups.

This pipeline is intended to be run on a SLURM-based HPC Cluster. It is expected
that bcl2fastq or BCL Convert has been run to produce paired FASTQ files.

### REQUIRED SOFTWARE
The software required for this pipeline is:
- Perl
- Python
- JupyterLab
- STAR

Required Python Libraries:
- seaborn
- matplotlib
- scanpy (realistically should install all following packages)
- AnnData
- numpy

Ordering of scripts:
1. `scRNA_align.sh` -> `scRNA_align.pl` (should output a folder)
2. `raw_scrna_processor.py` **OR** `scrna_visual_analysis.py` (should output a h5ad file)
3. `scrna_load_analysis.py`
