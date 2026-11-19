#  Join two tables on a shared column (i.e sampleID) in R

library(data.table)
a <- fread("<a.csv>")
b <- fread("<b.csv>")
fwrite(merge(a, b, by = "<key_column>"), "<out.csv>")
