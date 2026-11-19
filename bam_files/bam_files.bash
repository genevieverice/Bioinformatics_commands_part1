# Inspect and subset BAM files using samtools (bash)
# Region queries need a coordinate-sorted, indexed BAM

## header; sample, platform and tools that made the file
samtools view -H <in.bam>
samtools view -H <in.bam> | grep -E '^@(RG|PG)'

## first alignments
samtools view <in.bam> | head

## sort and index
samtools sort -@ <threads> -o <sorted.bam> <in.bam>
samtools index <sorted.bam>

## reads per contig
samtools idxstats <sorted.bam>

## find what the mitochondrial contig is called (chrM or MT)
samtools idxstats <sorted.bam> | cut -f1 | grep -iE "chrM|MT"

## mapping summary
samtools flagstat <sorted.bam>

## coverage per contig
samtools coverage <sorted.bam>

## extract one contig
samtools view -b -o <chrM.bam> <sorted.bam> chrM
samtools index <chrM.bam>

## keep primary alignments with mapping quality >= 20
## (-F 0x904 drops unmapped, secondary and supplementary)
samtools view -b -q 20 -F 0x904 <sorted.bam> > <filtered.bam>

## depth at every position of a region
samtools depth -a -r chrM <sorted.bam> > <depth.tsv>

## does the BAM carry modification calls? prints the MM tag of the first chrM read
## A+a = 6mA, C+m = 5mC, C+h = 5hmC
samtools view <sorted.bam> chrM | head -1 | tr '\t' '\n' | grep '^MM' | cut -c1-80
