# Combine per-sample CSVs into one wide matrix, then correlate and plot (python)
# wide matrix = one row per sample, one column per site

import pandas as pd
from pathlib import Path
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

## per-sample CSVs (pos, strand, beta_pct, cov) -> wide matrix with age and sex
meta = pd.read_csv("<metadata.csv>")

cols = []
for f in Path("<csv_dir>").glob("*_6mA.csv"):
    d = pd.read_csv(f)
    d = d[d["cov"] >= <min_cov>]
    d["site"] = d["pos"].astype(str) + d["strand"]
    cols.append(d.set_index("site")["beta_pct"].rename(f.name.replace("_6mA.csv", "")))

wide = pd.concat(cols, axis=1).T.dropna(axis=1)   # keep sites present in every sample
wide = meta.set_index("sampleID")[["age", "sex"]].join(wide, how="inner")
wide.to_csv("<wide_matrix.csv>")

## correlation of every site with age
sites = wide.drop(columns=["age", "sex"])
rho = sites.corrwith(wide["age"], method="spearman").sort_values()

## one scatter plot per site, saved to a single PDF
with PdfPages("<out.pdf>") as pdf:
    for site in sites.columns:
        plt.scatter(wide["age"], wide[site])
        plt.xlabel("age")
        plt.ylabel("beta_pct")
        plt.title(site)
        pdf.savefig()
        plt.close()
