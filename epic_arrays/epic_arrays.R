# EPIC methylation arrays: IDAT files to beta values, then epigenetic clocks (R)
# the phenotype file needs a Basename column: each sample's IDAT path
# without the _Grn.idat / _Red.idat ending

library(minfi)
library(methylclock)

## IDAT files -> normalised beta matrix (rows = probes, columns = samples)
## (functional normalisation needs a reasonable number of samples;
## for a handful, preprocessNoob(RGset) is the usual substitute)
targets <- read.csv("<phenofile.csv>")
RGset <- read.metharray.exp(targets = targets, force = TRUE)
GMset <- preprocessFunnorm(RGset)
GMset <- dropLociWithSnps(GMset, snps = c("CpG", "SBE"), maf = 0.01)
beta <- getBeta(GMset)

## published clocks: Horvath, Hannum, PhenoAge (Levine) and others
ages <- DNAmAge(beta)

## CpGs used by a clock
## (assign to an object first so it loads from the local cache)
horvath <- get_coefHorvath()
cpgs <- grep("^cg", horvath$CpGmarker, value = TRUE)
