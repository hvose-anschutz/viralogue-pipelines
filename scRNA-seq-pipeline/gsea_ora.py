#!/usr/bin/env python3

"""Calculates NES scores for a dataset"""

# STEP 1: Imports
import re
import os
import pprint
import warnings
import scanpy as sc
import anndata as ad
import seaborn as sns
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import gprofiler
import gseapy as gp
from gseapy import Biomart
import harmonypy as hm
import decoupler as dc

warnings.filterwarnings('ignore')
sns.set_style("ticks")
sns.set_theme(style="white", context="paper")

# STEP 2: Load Data
#live = sc.read_h5ad("20260423_live_recluster.h5ad")
#diet = sc.read_h5ad("20260423_diet_hm_recluster.h5ad")
live = sc.read_h5ad("adata_live_refiltered_20260507.h5ad")

# STEP 3: GENERATE DIFFERENT RESOLUTIONS OF CLUSTERING

for res in [0.2, 0.5, 0.75]:
    sc.tl.leiden(live, key_added=f"leiden_res_{res:4.2f}", resolution=res, flavor="igraph")

live_epcam = live[(live[:,'Epcam'].X.toarray() > 0.25) &
    (live[:, 'Ptprc'].X.toarray() < 0.01) &
    (live[:,'Cd79a'].X.toarray() < 0.01) &
    (live[:, 'Cd19'].X.toarray() < 0.01) &
    (live[:,'Cd3e'].X.toarray() < 0.01) &
    (live[:,'Cd3d'].X.toarray() < 0.01) &
    (live[:,'Cd3g'].X.toarray() < 0.01) &
    (live[:,'Cd247'].X.toarray() < 0.01)
].copy()

markers = dc.op.resource("PanglaoDB", organism="mouse")

# Filter by canonical_marker and human
markers = markers[
    markers["mouse"].astype(bool)
    & markers["canonical_marker"].astype(bool)
    & (markers["mouse_sensitivity"].astype(float) > 0.5)
]

# Remove duplicated entries
markers = markers[~markers.duplicated(["cell_type", "genesymbol"])]

# Format
markers = markers.rename(columns={"cell_type": "source", "genesymbol": "target"})
markers = markers[["source", "target"]]

dc.mt.ulm(data=live_epcam, net=markers, tmin=3)

score = dc.pp.get_obsm(live_epcam, key="score_ulm")
df = dc.tl.rankby_group(adata=score, groupby="leiden_res_0.75", reference="rest", method="t-test_overestim_var")
df = df[df["stat"] > 0]

n_ctypes = 3
ctypes_dict = df.groupby("group").head(n_ctypes).groupby("group")["name"].apply(lambda x: list(x)).to_dict()

for keys, vals in ctypes_dict.items():
    print(f"{keys}: {vals}\n")