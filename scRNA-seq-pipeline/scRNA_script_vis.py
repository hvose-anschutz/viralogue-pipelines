#!/usr/bin/env python3

"""Generates plots given a certain gene to generate a heatmap for. Assumes presence of h5ad file."""

#STEP 1: Imports
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

warnings.filterwarnings('ignore')

#STEP 2: Loading the dataset
adata_filtered = sc.read_h5ad("../../HollyData/adata_filtered_1032025.h5ad")

#STEP 2.5: Redefine prior categories, may not be necessary
adata_filtered.obs.loc[adata_filtered.obs["i_type"] == "infected", 'group'] = '5DPI'
adata_filtered.obs.loc[adata_filtered.obs["i_type"] == "uninfected", 'group'] = 'Mock'

#STEP 3: Load color palettes
infected_colors = {
    "5DPI": "#e88048",
    "Mock": "#582B36"
}

cluster_colors = ["#2E5283","#AC6C29","#C67FAE","#D7E8BC","#E2552D","#009499","#6D5698","#E3BD33","#98DDDF","#582B36","#A6BE47"]
i_contrast_colors = ["#E2552D","#2E5283"]
ifitm_hex = ["#BEBDBD", "#DF3848"]
dp_hex = ["#FFFFFF","#0075B8"]
aggressive_hex = ["#FFFFFF","#000000"]

ifitm_cmap = mcolors.LinearSegmentedColormap.from_list("ifitm_cmap",ifitm_hex)
aggr_cmap = mcolors.LinearSegmentedColormap.from_list("aggr_cmap",aggressive_hex)
dp_cmap = mcolors.LinearSegmentedColormap.from_list("dp_cmap",dp_hex)

#STEP 4: CLUSTER DEFINITIONS
#Stem Cell: Lgr5+, Ascl2+, Muc2-, Lrig1+ (ideally)
#Tuft Cell: Dclk1+
#Colonocytes: Slc26a3+, Krt20+, Aqp8+
#TA Cells: Foxm1, Ube2c+
#Goblet Cell Progenitor: Spdef+, Atoh1+
#Goblet Cell: Reg4+, Spink4+, Tff3+, Fad3+
#Immune Signaling Cells: B2m+, Cd3g+
#EC Progenitors: B3galt5+
#Actin-Associated Genes: Actb+, Car1, Krt8

cluster2annotation = {
    "0": "Stem Cell",
    "1": "Mitochondrial-Associated Cell Stress",
    "2": "Goblet Cell", 
    "3": "Stem Cell", 
    "4": "Goblet Cell Progenitor", 
    "5": "Mitochondrial-Associated Cell Stress",
    "6": "Goblet Cell",
    "7": "Goblet Cell",
    "8": "Absorptive Colonocytes",
    "9": "Transit Amplifying Cells",
    "10": "Tuft Cells",
    "11": "Transit Amplifying Cells",
    "12": "Epithelial Cell Progenitors",
    "13": "Goblet Cell",
    "14": "Mature Enterocytes",
    "15": "Goblet Cell", 
    "16": "Absorptive Colonocytes", 
    "17": "Absorptive Colonocytes",
    "18": "Other",
    "19": "Actin-Associated Cell Stress",
}

adata_filtered.obs['cluster_cell_type'] = adata_filtered.obs["leiden"].map(cluster2annotation).astype('category')

#PLOTTING

#basic format for a few things:
# sc.pl.umap(adata_filtered, color=[gene], size=20, mask_obs=(adata_filtered.obs.[category]==[group]), cmap=[colormap], frameon=False, save=[output filename])

#BASIC PLOTS
#sc.pl.umap(adata_filtered, color=["cluster_cell_type"],palette=cluster_colors,frameon=False)
#sc.pl.umap(adata_filtered, color="group",groups="5DPI",frameon=False,palette=i_contrast_colors)
sc.pl.umap(adata_filtered, color="Krt20",frameon=False,cmap=ifitm_cmap,save="krt20.svg")
sc.pl.umap(adata_filtered, color="Krt20",frameon=False,cmap=ifitm_cmap,mask_obs=(adata_filtered.obs.group=="Mock"))
sc.pl.umap(adata_filtered, color="Scin",frameon=False,cmap=ifitm_cmap,mask_obs=(adata_filtered.obs.group=="5DPI"))
#sc.pl.umap(adata_filtered, color="group", frameon=False,palette=i_contrast_colors,title="cell sample types",save="sampleumap.svg")
# sc.pl.umap(adata_filtered, color="cluster_cell_type", frameon=False, title="cell clustering",save="i_contrast.jpg")
