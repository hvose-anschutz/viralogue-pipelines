#!/usr/bin/env python3

#IMPORTS
import scanpy as sc
import scanpy as sc
import anndata as ad
import seaborn as sns
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import pprint
import warnings

warnings.filterwarnings('ignore')

#SAMPLES
filtered_samples = {
    "MHVY_Colon_5dpi_1": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/scRNA_SAM_mixed/MHVY_Colon_5dpi_1_GEX/Gene/raw",
    "MHVY_Colon_5dpi_2": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/scRNA_SAM_mixed/MHVY_Colon_5dpi_2_GEX/Gene/raw",
    "MHVY_Colon_5dpi_3": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/scRNA_SAM_mixed/MHVY_Colon_5dpi_3_GEX/Gene/raw",
    "Uninfected_1": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/scRNA_SAM_mixed/Uninfected_1_GEX/Gene/raw",
    "Uninfected_2": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/scRNA_SAM_mixed/Uninfected_2_GEX/Gene/raw",
    "Uninfected_3": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/scRNA_SAM_mixed/Uninfected_3_GEX/Gene/raw"
}

adatas = {}

for sample_id, filename in filtered_samples.items():
    sample_adata = sc.read_10x_mtx(filename,compressed=False)
    sample_adata.var_names_make_unique()
    adatas[sample_id] = sample_adata

adata = ad.concat(adatas, label="sample")
adata.obs['i_type'] = 'Mock'
adata.obs_names_make_unique()

adata.obs.loc[adata.obs["sample"] == "MHVY_Colon_5dpi_1", 'i_type'] = '5DPI'
adata.obs.loc[adata.obs["sample"] == "MHVY_Colon_5dpi_2", 'i_type'] = '5DPI'
adata.obs.loc[adata.obs["sample"] == "MHVY_Colon_5dpi_3", 'i_type'] = '5DPI'

adata.var["mhvy"] = adata.var_names.str.contains("Mhvy")

sc.pp.calculate_qc_metrics(
    adata, qc_vars=["mhvy"], inplace=True, log1p=True
)

#mhvy filtering
mhvy_filtered = adata[adata.obs['pct_counts_mhvy']>0].obs_names

#whole cell filtering
sc.pp.filter_cells(adata, min_genes=1)
sc.pp.filter_genes(adata, min_cells=1)
sc.pp.scrublet(adata, batch_key="sample")

# Saving count data
adata.layers["counts"] = adata.X.copy()
# Normalizing to median total counts
sc.pp.normalize_total(adata)
# Logarithmize the data
sc.pp.log1p(adata)

#highly variable gene thresholding
sc.pp.highly_variable_genes(adata, n_top_genes=2000, batch_key="i_type")

#doublet filtering
adata_filtered = adata_mid_filter[~adata_mid_filter.obs['predicted_doublet']].copy()

adata_filtered.write_h5ad("adata_filtered_raw_10102025.h5ad")
