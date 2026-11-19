# Convert between file formats in R (csv/tsv/bed/bedMethyl)

library(data.table)

## CSV -> TSV
fwrite(fread("<in.csv>"), "<out.tsv>", sep = "\t")

## TSV -> CSV
fwrite(fread("<in.tsv>"), "<out.csv>")

## CSV with header (chr, 1-based pos) -> BED (no header, 0-based start)
d <- fread("<in.csv>")
fwrite(d[, .(chr, pos - 1, pos)], "<out.bed>", sep = "\t", col.names = FALSE)

## BED -> CSV with 1-based position
b <- fread("<in.bed>", select = 1:2, col.names = c("chr", "start"))
fwrite(b[, .(chr, pos = start + 1)], "<out.csv>")

## bedMethyl -> CSV of 6mA calls (mod code a) with 1-based positions
m <- read.table("<in_bedmethyl.bed>")
m <- m[m$V4 == "a", ]
fwrite(data.table(pos = m$V2 + 1, strand = m$V6, mod_code = m$V4, beta_pct = m$V11, cov = m$V10), "<out.csv>")
