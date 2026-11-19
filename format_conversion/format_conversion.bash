# Convert between file formats using bash (csv/tsv/bed/bedMethyl)

## CSV -> TSV (only safe when no value contains a comma)
cat <in.csv> | tr ',' '\t' > <out.tsv>

## TSV -> CSV
cat <in.tsv> | tr '\t' ',' > <out.csv>

## CSV with header (chr, 1-based pos) -> BED (no header, 0-based start)
awk -F, 'BEGIN{OFS="\t"} NR>1 {print $1, $2-1, $2}' <in.csv> > <out.bed>

## BED -> CSV with 1-based position
awk 'BEGIN{OFS=","; print "chr,pos"} {print $1, $2+1}' <in.bed> > <out.csv>

## bedMethyl -> CSV of 6mA calls (mod code a) with 1-based positions
awk 'BEGIN{OFS=","; print "pos,strand,mod_code,beta_pct,cov"} $4=="a" {print $2+1, $6, $4, $11, $10}' <in_bedmethyl.bed> > <out.csv>

## sort a BED file by chromosome, then start position
sort -k1,1 -k2,2n <in.bed> > <sorted.bed>
