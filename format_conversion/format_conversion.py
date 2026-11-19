# Convert between file formats in python (csv/tsv/bed/bedMethyl)

import pandas as pd

## CSV -> TSV
pd.read_csv("<in.csv>").to_csv("<out.tsv>", sep="\t", index=False)

## TSV -> CSV
pd.read_csv("<in.tsv>", sep="\t").to_csv("<out.csv>", index=False)

## CSV with header (chr, 1-based pos) -> BED (no header, 0-based start)
d = pd.read_csv("<in.csv>")
d.assign(start=d["pos"] - 1)[["chr", "start", "pos"]].to_csv("<out.bed>", sep="\t", header=False, index=False)

## BED -> CSV with 1-based position
b = pd.read_csv("<in.bed>", sep="\t", header=None, usecols=[0, 1], names=["chr", "start"])
b.assign(pos=b["start"] + 1)[["chr", "pos"]].to_csv("<out.csv>", index=False)

## bedMethyl -> CSV of 6mA calls (mod code a) with 1-based positions
m = pd.read_csv("<in_bedmethyl.bed>", sep=r"\s+", header=None, usecols=[1, 3, 5, 9, 10], names=["start", "mod_code", "strand", "cov", "beta_pct"])
m = m[m["mod_code"] == "a"]
m.assign(pos=m["start"] + 1)[["pos", "strand", "mod_code", "beta_pct", "cov"]].to_csv("<out.csv>", index=False)
