#!/usr/bin/env python3

"""Removes batch effects from a given scRNA file"""

import warnings
import scanpy as sc
import anndata as ad
import seaborn as sns
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

adata_diet_filtered = sc.read_h5ad("20260423_treatment_recluster.h5ad")

sc.pp.combat(adata_diet_filtered, key="treatment")

sc.pl.umap(adata_diet_filtered,color='treatment',save='treatment_unbatch.png')