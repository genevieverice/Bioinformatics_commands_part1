# Compare sets of genomic positions using bedtools (bash)
# A bedMethyl file is a BED file, so it works as input directly

## pileup rows that fall on a list of positions, such as array CpGs
bedtools intersect -a <in_bedmethyl.bed> -b <positions.bed> -u > <out_bedmethyl.bed>

## the same, with the matching row of B (for example its probe ID) appended
bedtools intersect -a <in_bedmethyl.bed> -b <positions.bed> -wa -wb > <out.bed>

## rows of A that overlap nothing in B
bedtools intersect -a <a.bed> -b <b.bed> -v > <out.bed>

## sequence of each interval
bedtools getfasta -fi ~/GRCh38.fa -bed <regions.bed> -fo <out.fasta>
