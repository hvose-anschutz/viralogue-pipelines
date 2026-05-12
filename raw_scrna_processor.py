#!/usr/bin/env python3

#IMPORTS
import scanpy as sc
import anndata as ad
import seaborn as sns
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import pprint
import warnings
import doubletdetection

warnings.filterwarnings('ignore')

#SAMPLES
#STEP 2: LOAD THE SAMPLES
#Loads all outputted alignment files into a dictionary with corresponding sample names.
filtered_samples = {"sample_1":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample1/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_2":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample2/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_3":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample3/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_4":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample4/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_5":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample5/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_6":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample6/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_7":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample7/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_8":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample8/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_9":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample9/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_10":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample10/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_11":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample11/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_12":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample12/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_13":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample13/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_14":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample14/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_15":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample15/count/sample_filtered_feature_bc_matrix.h5",
                   "sample_16":"/scratch/alpine/hvose@xsede.org/fixed_scRNA/fixed_scRNA_run1/outs/per_sample_outs/sample16/count/sample_filtered_feature_bc_matrix.h5"}

adatas = {}

for sample_id, filename in filtered_samples.items():
    sample_adata = sc.read_10x_mtx(filename,compressed=False)
    sample_adata.var_names_make_unique()
    adatas[sample_id] = sample_adata

adata = ad.concat(adatas, label="sample")
adata.obs_names_make_unique()

#adata.var["mhvy"] = adata.var_names.str.contains("Mhvy")

sc.pp.calculate_qc_metrics(
    adata, qc_vars=["mt"], inplace=True, log1p=True
)

#STEP 5: Filtering for just MHV-Y positive barcodes (or getting rid of cells with too high of a mitochondrial count)
adata = adata[adata.obs['pct_counts_mt']<10]

#whole cell filtering
sc.pp.filter_cells(adata, min_genes=10)
sc.pp.filter_genes(adata, min_cells=1)
sc.pp.scrublet(adata, batch_key="sample")

clf = doubletdetection.BoostClassifier(
    n_iters=10, 
    clustering_algorithm="leiden", 
    standard_scaling=True,
    pseudocount=0.1,
    n_jobs=-1,
)
doublets = clf.fit(adata.X).predict(p_thresh=1e-16, voter_thresh=0.5)
doublet_score = clf.doublet_score()

adata.obs["doublet"] = doublets
adata.obs["doublet_score"] = doublet_score

# Saving count data
adata.layers["counts"] = adata.X.copy()

sc.pp.normalize_total(adata)
sc.pp.log1p(adata)

#highly variable gene thresholding
sc.pp.highly_variable_genes(adata, n_top_genes=2000)

sc.tl.pca(adata)
sc.pp.neighbors(adata)
sc.tl.umap(adata)

to_print = ["doublet", "doublet_score"]

for col in to_print:
    sc.pl.umap(adata, color=col, save=f"{col}_umap.png")

#doublet filtering
#adata_filtered = adata_mid_filter[~adata_mid_filter.obs['predicted_doublet']].copy()

#adata_filtered.write_h5ad("adata_filtered_raw_10102025.h5ad")
