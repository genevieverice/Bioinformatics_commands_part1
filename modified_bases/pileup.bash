# Pile up modified bases (6mA, 5mC, 5hmC) from long-read BAMs (bash)
# modkit for Nanopore, ft (fibertools) for PacBio; both need a BAM with MM/ML tags
# Flags differ between modkit versions: check modkit pileup --help when one is refused

## Nanopore: pileup of one contig to a bedMethyl file, default filtering
## (with no --filter-threshold, modkit estimates a threshold per sample that drops
## the least confident 10% of calls; use the same setting for every sample in a cohort)
modkit pileup <in.bam> <out_bedmethyl.bed> --region chrM --threads <threads>

## only reference adenines, with one fixed threshold for every sample
modkit pileup <in.bam> <out_bedmethyl.bed> --ref ~/GRCh38.fa --motif A 0 --region chrM --filter-threshold A:<threshold> --threads <threads>

## keep the bedMethyl, then make the CSV (&& runs awk only if modkit succeeded)
modkit pileup <in.bam> <out_bedmethyl.bed> --region chrM --threads <threads> &&
awk 'BEGIN{OFS=","; print "pos,strand,mod_code,beta_pct,cov"} $4=="a" {print $2+1, $6, $4, $11, $10}' <out_bedmethyl.bed> > <out.csv>

## or pipe straight to the CSV: - in place of the output file sends results down the pipe
modkit pileup <in.bam> - --region chrM --threads <threads> |
awk 'BEGIN{OFS=","; print "pos,strand,mod_code,beta_pct,cov"} $4=="a" {print $2+1, $6, $4, $11, $10}' > <out.csv>

## every BAM in a folder
for bam in <bam_dir>/*.bam; do
  s=$(basename "$bam" .bam)
  modkit pileup "$bam" "<bed_dir>/${s}.bed" --region chrM --threads <threads>
done

## PacBio: 6mA pileup with fibertools
## (no strand column: the reference base gives it, A is + and T is -;
## beta is m6a_coverage / coverage)
ft pileup <in.bam> --rgn chrM --m6a --threads <threads> > <out.bed>
