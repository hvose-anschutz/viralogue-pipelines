#!/usr/bin/env python3

"""Runs SoupX ambient RNA removal on large datasets too big for the JupyterLab kernel. \
Outputs a h5ad file with the removed RNA, which can then be loaded for further processing."""

import warnings
import scanpy as sc
import scanpy as sc
import anndata as ad
import seaborn as sns
import numpy as np
import pandas as pd
import soupx

warnings.filterwarnings('ignore')

experiment = "live"

filtered_samples = {"MHVY_Colon_5dpi_1": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/MHVY_Colon_5dpi_1/Solo.out/Gene/filtered/",
                   "MHVY_Colon_5dpi_2": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/MHVY_Colon_5dpi_2/Solo.out/Gene/filtered/",
                   "MHVY_Colon_5dpi_3": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/MHVY_Colon_5dpi_3/Solo.out/Gene/filtered/",
                   "Uninfected_1": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/Uninfected_1/Solo.out/Gene/filtered/",
                   "Uninfected_2": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/Uninfected_2/Solo.out/Gene/filtered/",
                   "Uninfected_3": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/Uninfected_3/Solo.out/Gene/filtered/"}

raw_samples = {"MHVY_Colon_5dpi_1": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/MHVY_Colon_5dpi_1/Solo.out/Gene/raw/",
                   "MHVY_Colon_5dpi_2": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/MHVY_Colon_5dpi_2/Solo.out/Gene/raw/",
                   "MHVY_Colon_5dpi_3": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/MHVY_Colon_5dpi_3/Solo.out/Gene/raw/",
                   "Uninfected_1": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/Uninfected_1/Solo.out/Gene/raw/",
                   "Uninfected_2": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/Uninfected_2/Solo.out/Gene/raw/",
                   "Uninfected_3": "/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/STAR_scRNA/Uninfected_3/Solo.out/Gene/raw/"}

#STEP 3: GENERATE ANNDATA OBJECT WITH SAMPLES
#For each item in our dictionary, we want to read in the info, make the cells unique, and then combine them into a single object
#Additionally, we are going to add an "infection type" (i_type) column that specifies the infection type based on the loaded sample.

adatas = {}
adatas_raw = {}

for sample_id, filename in filtered_samples.items():
    if experiment != "live":
        sample_adata = sc.read_10x_h5(filename)
    else:
        sample_adata = sc.read_10x_mtx(filename,compressed=False)
    sample_adata.var_names_make_unique()
    adatas[sample_id] = sample_adata

adata = ad.concat(adatas, label="sample")
adata.obs_names_make_unique()

for sample_id, filename in raw_samples.items():
    if experiment != "live":
        sample_adata_r = sc.read_10x_h5(filename)
    else:
        sample_adata_r = sc.read_10x_mtx(filename,compressed=False)
    sample_adata_r.var_names_make_unique()
    adatas_raw[sample_id] = sample_adata_r

adata_raw = ad.concat(adatas_raw, label="sample")
adata_raw.obs_names_make_unique()


if experiment == "dHE":
    adata.obs["condition"] = "Mock"
    adata_raw.obs["condition"] = "Mock"
    
    for i in range(1,16):
        match i:
            case val if 6<=int(val)<=10:
                adata.obs.loc[adata.obs["sample"] == f"sample_{i}", "condition"] = "dHE"
                adata_raw.obs.loc[adata.obs["sample"] == f"sample_{i}", "condition"] = "dHE"
            case val if 11<=int(val)<=15:
                adata.obs.loc[adata.obs["sample"] == f"sample_{i}", "condition"] = "MHVY"
                adata_raw.obs.loc[adata_raw.obs["sample"] == f"sample_{i}", "condition"] = "MHVY"
                
elif experiment == "fiber":
    adata.obs["treatment"] = "Mock"
    adata_raw.obs["treatment"] = "Mock"
    
    for i in range(1,16):
        match i:
            case val if 1<=int(val)<=5:
                adata.obs.loc[adata.obs["sample"] == f"sample_{i}", "treatment"] = "no_fiber"
                adata_raw.obs.loc[adata_raw.obs["sample"] == f"sample_{i}", "treatment"] = "no_fiber"
            case val if 6<=int(val)<=10:
                adata.obs.loc[adata.obs["sample"] == f"sample_{i}", "treatment"] = "amp"
                adata_raw.obs.loc[adata_raw.obs["sample"] == f"sample_{i}", "treatment"] = "amp"
elif experiment == "live":
    adata.obs["i_type"] = "Mock"
    for i in range(1,4):
        adata.obs.loc[adata.obs["sample"] == f"MHVY_Colon_5dpi_{i}", "i_type"] = "5DPI"
else:
    print("ERROR! no valid experiment selected")

if int(adata.n_vars) != int(adata_raw.n_vars):
    adata_raw = adata_raw[: , adata.var_names].copy()

print("Current adata object sizes (cells x genes):\n")
print(f"filtered: {adata.shape}")
print(f"raw: {adata_raw.shape}")

# Create SoupChannel
soup_channel = soupx.SoupChannel(
    tod=adata_raw.X.T.tocsr(),    # table of droplets: raw counts (genes × droplets)
    toc=adata.X.T.tocsr(), # table of counts: filtered counts (genes × cells)
    metaData=pd.DataFrame(index=adata.obs_names)
)

# Add clustering information (essential for good results)
sc.pp.neighbors(adata)
sc.tl.leiden(adata, resolution=0.5)
soup_channel.setClusters(adata.obs['leiden'].values)

# Estimate and remove contamination
soup_channel = soupx.autoEstCont(soup_channel, soup_quantile=0.9, verbose=True)
corrected_matrix = soupx.adjustCounts(soup_channel)

# Replace counts in AnnData object
adata_corrected = adata.copy()
adata_corrected.X = corrected_matrix.T  # Convert back to cells × genes

adata_corrected.write_h5ad(f"soupx_filtered_{experiment}_20260604.h5ad")
