# Inspect tables using bash (csv/tsv/txt)

## see whats in the first few lines of a file (also works for gzipped files)
head -n 5 <table.csv>
zcat <table.csv.gz> | head -n 5

## number of lines
wc -l <table.csv>

## view a CSV but align the columns (q to quit)
column -t -s, <table.csv> | less -S

## keep columns 1 and 3 of a CSV
cut -d, -f1,3 <table.csv> > <out.csv>

## keep the header plus rows where column 5 is at least 10
awk -F, 'NR==1 || $5 >= 10' <table.csv> > <out.csv>

## count how often each value occurs in column 2
cut -d, -f2 <table.csv> | sort | uniq -c | sort -k1,1nr

## line counts for every file in a folder
wc -l <csv_dir>/*.csv

## strip a prefix from many file names (PREFIX_sample_6mA.csv -> sample_6mA.csv)
for f in <csv_dir>/*_6mA.csv; do mv "$f" "<csv_dir>/$(basename "$f" | cut -d_ -f2-)"; done
