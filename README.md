# Bioinformatics_reference_guide
A quick reference for some general bioinformatics terminology/tools/tasks, and (epi)genetics analysis of nanopore data

## Contents
- [Vocabulary](#vocabulary)
- [Tools and Tasks](#tools-and-tasks)
- [slurm_cluster/](slurm_cluster): working on the cluster
  - [cluster101.bash](slurm_cluster/cluster101.bash): logging in, worker nodes, L-drive, conda setup
  - [slurm_jobs.bash](slurm_cluster/slurm_jobs.bash): job options, batch scripts, checking on jobs
  - [tmux.bash](slurm_cluster/tmux.bash): keeping sessions running with tmux
- [tables/](tables): looking at and joining text tables
  - [tables.bash](tables/tables.bash): inspect, filter and count in csv/tsv/txt files
  - [tables.R](tables/tables.R): join two tables on a shared column
  - [tables.py](tables/tables.py): join two tables on a shared column
- [format_conversion/](format_conversion): converting between csv, tsv, bed and bedMethyl
  - [format_conversion.bash](format_conversion/format_conversion.bash)
  - [format_conversion.R](format_conversion/format_conversion.R)
  - [format_conversion.py](format_conversion/format_conversion.py)
- [bam_files/](bam_files)
  - [bam_files.bash](bam_files/bam_files.bash): inspect and subset BAM files with samtools
- [modified_bases/](modified_bases)
  - [modified_bases.bash](modified_bases/modified_bases.bash): pile up 6mA, 5mC and 5hmC with modkit and fibertools
- [genomic_intervals/](genomic_intervals)
  - [genomic_intervals.bash](genomic_intervals/genomic_intervals.bash): compare sets of positions with bedtools
- [matrices_plots/](matrices_plots)
  - [matrices_plots.py](matrices_plots/matrices_plots.py): per-sample CSVs to a wide matrix, correlations, plots
- [elastic_net/](elastic_net)
  - [elastic_net.R](elastic_net/elastic_net.R): age prediction with glmnet and leave-one-out cross-validation
- [epic_arrays/](epic_arrays)
  - [epic_arrays.R](epic_arrays/epic_arrays.R): IDAT files to beta values, epigenetic clocks


## Vocabulary 
| Category | Term | Definition |
| --- | --- | --- |
| General | Workflow (pipeline) | Several steps chained into a full analysis |
| General | Reproducibility | Being able to rerun an analysis and get the same result |
| General | Dependency | Software another tool needs in order to run |
| General | Environment | An isolated set of installed tools and versions, such as a conda environment |
| General | Repository (repo) | A project folder tracked by git |
| General | Commit | A saved snapshot of changes in a repository |
| General | Metadata | Information about samples: age, sex, sample ID, group |
| General | Cohort | The set of individuals in a study |
| Cluster | Cluster (HPC) | Many linked computers shared by users |
| Cluster | Login node | The entry computer: for editing and submitting, not heavy work |
| Cluster | Compute node | A computer that runs the jobs |
| Cluster | Scheduler | Software that queues and assigns jobs, such as slurm |
| Cluster | Job | One unit of work submitted to the scheduler |
| Cluster | Interactive job | A live session on a compute node, via `srun` |
| Cluster | Batch job | A script that runs unattended, via `sbatch` |
| Cluster | Partition (queue) | A group of nodes with shared limits |
| Cluster | Resources | What a job requests: cores, memory, time |
| Cluster | Walltime | The maximum real time a job may run |
| Cluster | Threads (cores) | Parallel workers a tool can use |
| Cluster | Terminal multiplexer | A tool such as `tmux` that keeps sessions alive after you disconnect |
| Cluster | Kerberos ticket | A time-limited login token for network drives, renewed with `kinit` |
| Cluster | Network share | A drive mounted from another server |
| Shell | Shell (terminal) | The text interface where you type commands |
| Shell | Bash | The most common shell language on Linux |
| Shell | Command-line tool | A standalone program run from the shell, such as `samtools` |
| Shell | Command | One invocation of a tool |
| Shell | Subcommand | A function within a tool, such as `pileup` in `modkit pileup` |
| Shell | Option (flag) | A setting that changes how a command behaves, such as `--region` |
| Shell | Argument | A value you give a command: a file, a region, a number |
| Shell | Positional argument | An argument identified by its position rather than a flag |
| Shell | Pipe | The `\|` symbol, which sends one command's output into the next |
| Shell | Redirection | Sending output to a file with `>` or reading input with `<` |
| Shell | `&&` | Runs the next command only if the previous one succeeded |
| Shell | Standard input (stdin) | The data stream a command reads when no file is given |
| Shell | Standard output (stdout) | The data stream a command writes its results to; `-` often stands for it |
| Shell | Standard error (stderr) | The separate stream for messages and errors |
| Shell | Stream | Data processed line by line without loading the whole file |
| Shell | One-liner | A command or chain of piped commands on one line |
| Shell | Script | A file of commands run together |
| Shell | Variable | A named value, read with `$name` in bash |
| Shell | Loop | Repeating commands over a list, such as every BAM in a folder |
| Shell | Wildcard (glob) | A pattern such as `*.bam` matching many file names |
| Shell | Path | The location of a file; absolute from `/`, relative from the current folder |
| Shell | Working directory | The folder a command runs in |
| Shell | Regular expression (regex) | A pattern language for matching text |
| Shell | Exit status | A number a command returns: 0 for success, 137 for killed (often out of memory) |
| Shell | Quoting | Wrapping text in `'...'` or `"..."` so the shell passes it on unchanged |
| Code | Library (package) | Code loaded inside R or Python, such as `glmnet` or `pandas` |
| Code | Function | A named operation called with arguments |
| Code | Object | A data structure in memory, such as a fitted model |
| Code | Data frame | A table in R or Python with named columns |
| Code | Matrix | A grid of numbers with rows and columns, such as samples by sites |
| Code | Long / wide format | One row per sample-site pair, versus one row per sample and one column per site |
| Code | Snippet | A short piece of code |
| Code | Template | A command or script with placeholders to fill in |
| Code | Placeholder | A stand-in for your own value, written as `<name>` |
| Code | Notebook | A document mixing code cells and their output, such as Jupyter |
| Code | Vignette | A worked example distributed with an R package |
| Files | Plain text file | A file readable as text: CSV, TSV, BED |
| Files | Binary file | A compact file needing a specific tool to read: BAM, IDAT |
| Files | Delimiter | The character separating columns: tab or comma |
| Files | Header | Lines at the top describing the content or columns |
| Files | Field (column) | One value position in a row |
| Files | Record | One row or entry: one read, one position |
| Files | Parse | Reading a file and extracting its fields |
| Files | Compression | Shrinking a file, with `gzip` or the indexable `bgzip` |
| Files | Index | A companion file allowing fast lookup by position: `.bai`, `.fai` |
| Files | Coordinate-sorted | Records ordered by chromosome and position |
| Files | Line endings | Windows (CRLF) versus Linux (LF); the wrong kind breaks bash scripts |
| File Formats | FASTA | Sequences with a name line, such as a reference genome |
| File Formats | FASTQ | Sequencing reads with per-base quality scores |
| File Formats | SAM / BAM / CRAM | Aligned reads as text, binary, and reference-compressed |
| File Formats | BED | Genomic intervals: chromosome, start, end |
| File Formats | bedMethyl | A BED file with per-position modification counts, written by `modkit pileup` |
| File Formats | IDAT | Raw intensity file from an Illumina methylation array |
| File Formats | RDS | A single saved R object |
| Reference | Reference genome | The standard sequence that reads are compared against |
| Reference | Genome build (assembly) | A version of the reference, such as GRCh38 |
| Reference | Analysis set | A build prepared for alignment, with decoys and masked regions |
| Reference | Contig | One continuous sequence in a reference; the mitochondrial one is `chrM` or `MT` |
| Reference | rCRS | The revised Cambridge Reference Sequence, the standard human mtDNA reference |
| Reference | Interval (region) | A stretch of genome given as chromosome, start, end |
| Reference | Coordinate system | 0-based half-open (BED, bedMethyl) or 1-based closed (most tables) |
| Reference | Strand | Which DNA strand a base lies on: + or - |
| Reference | Motif | A short sequence pattern that restricts which positions are reported, such as `CG` |
| Sequencing | Read | One sequenced fragment |
| Sequencing | Long read | A read of kilobases, from Nanopore (ONT) or PacBio |
| Sequencing | HiFi (CCS) read | A PacBio read built from several passes over one molecule |
| Sequencing | Library | The prepared DNA sample loaded on the sequencer |
| Sequencing | Basecalling | Converting raw sequencer signal into bases |
| Sequencing | Basecaller model | The model used for basecalling; it decides which modifications are called |
| Sequencing | Base quality (Phred score) | The confidence in each base call; Q30 is 1 error in 1,000 |
| Sequencing | Depth (coverage) | How many reads cover a position |
| Sequencing | Whole-genome amplification (WGA) | Copying DNA enzymatically, which erases modifications; used as a negative control |
| Sequencing | Batch effect | Technical differences between groups of samples processed separately |
| Alignment | Alignment (mapping) | Finding where each read came from in the reference |
| Alignment | Aligner | A tool that does this, such as `minimap2` |
| Alignment | Mapping quality (MAPQ) | The confidence that a read is placed correctly |
| Alignment | Flag | A number encoding read properties: unmapped, reverse strand, secondary |
| Alignment | Primary alignment | The best placement of a read |
| Alignment | Secondary alignment | An alternative placement of the same read |
| Alignment | Supplementary alignment | Part of a read that maps elsewhere (split read) |
| Alignment | Tag | An extra field on a read, such as `MM` or `HP` |
| Alignment | Read group (`@RG`) | A header line and tag linking reads to a sample, platform and run |
| Alignment | Program line (`@PG`) | A header line recording which tools produced the BAM |
| Alignment | Haplotagged | Reads labelled with the parental haplotype they came from |
| Alignment | Pileup | All read bases, or modification calls, stacked at each reference position |
| Methylation | Modified base | A chemically altered base, such as 6mA or 5mC |
| Methylation | 6mA | N6-methyladenine, a methylated adenine |
| Methylation | 5mC / 5hmC | Methylated and hydroxymethylated cytosine |
| Methylation | CpG | A cytosine followed by a guanine, where most human 5mC occurs |
| Methylation | Modification code | The letter for a modification in tags and bedMethyl: `a`, `m`, `h` |
| Methylation | MM / ML tags | BAM tags holding each read's modification positions and probabilities |
| Methylation | Modification probability | The caller's confidence that a base is modified |
| Methylation | Filter threshold | The probability below which calls are discarded |
| Methylation | Valid coverage | The number of reads with a confident call at a position |
| Methylation | Beta value | The fraction of reads (or array signal) that is methylated, 0 to 1 or 0 to 100% |
| Methylation | Site | One position tested for modification |
| Methylation | Fiber-seq | A PacBio assay that marks open chromatin with added 6mA |
| Methylation | Heteroplasmy | The fraction of mitochondrial DNA copies carrying a variant |
| Arrays | Methylation array | A chip measuring methylation at fixed CpGs: 450k, EPIC v1, EPIC v2 |
| Arrays | Probe | The array feature measuring one CpG, with an ID such as `cg00000029` |
| Arrays | Manifest | The file describing every probe on an array |
| Arrays | Normalization | Removing technical variation between arrays: Noob, functional normalisation |
| Arrays | Detection p-value | Whether a probe's signal is distinguishable from background |
| Arrays | Cross-reactive probe | A probe that binds more than one place in the genome |
| Arrays | Epigenetic clock | A model predicting age from methylation: Horvath, Hannum, PhenoAge, GrimAge |
| Arrays | Age acceleration | Predicted age minus chronological age |
| Modelling | Predictor (feature) | An input variable to a model, here a site's beta value |
| Modelling | Outcome (response) | What the model predicts, here age |
| Modelling | Regularization | Penalising large coefficients to prevent overfitting |
| Modelling | Elastic net | A regression mixing lasso and ridge penalties |
| Modelling | Alpha | The mix between ridge (0) and lasso (1) |
| Modelling | Lambda | The strength of the penalty, usually tuned by cross-validation |
| Modelling | Cross-validation (CV) | Fitting on part of the data and testing on the rest, repeatedly |
| Modelling | Leave-one-out (LOOCV) | Cross-validation leaving out one sample at a time |
| Modelling | Nested cross-validation | An inner loop tunes the model; an outer loop estimates performance |
| Modelling | Data leakage | Information from test samples reaching the training step |
| Modelling | Overfitting | A model fitting noise, so it performs worse on new data |
| Modelling | Standardisation (z-score) | Rescaling each predictor to mean 0 and standard deviation 1 |
| Modelling | Coefficient | The weight a model gives a predictor |
| Modelling | Imputation | Filling in missing values |
| Modelling | MAE / RMSE | Mean absolute error and root mean squared error of predictions |
| Modelling | Pearson / Spearman correlation | Linear versus rank-based association |
| Modelling | R² | The fraction of variance explained, here the squared correlation |
| Modelling | Multiple testing correction | Adjusting p-values when testing many sites (FDR) |



## Tools and Tasks
| Tool | Language | Usage | Example | 
| --- | --- | --- | --- |
| `head` | bash | Prints the first lines of a file, so you can check its layout without opening all of it | `head -n 5 <table.csv>` |
| `wc` | bash | Counts lines, words or characters; with `-l` it gives the number of rows in a file | `wc -l <table.csv>` |
| `cut` | bash | Keeps chosen columns of a delimited text file | `cut -d, -f1,3 <table.csv> > <out.csv>` |
| `sort` | bash | Orders the lines of a file by one or more columns, as text or as numbers | `sort -k1,1 -k2,2n <in.bed> > <sorted.bed>` |
| `uniq` | bash | Collapses repeated neighbouring lines; after `sort`, `uniq -c` counts how often each value occurs | `cut -d, -f2 <table.csv> \| sort \| uniq -c` |
| `grep` | bash | Prints the lines of a file matching a word or pattern | `grep -w "<sample_id>" <metadata.csv>` |
| `awk` | bash | Reads a text file line by line and works on its columns; filters rows, reorders columns, converts between CSV, BED and bedMethyl | `awk -F, 'NR==1 \|\| $5 >= 10' <table.csv> > <out.csv>` |
| `samtools` | bash | Reads and writes SAM, BAM and CRAM files; views headers and reads, sorts, indexes, extracts a region, counts reads | `samtools view -b -o <chrM.bam> <sorted.bam> chrM` |
| `modkit` | bash | Oxford Nanopore's tool for BAMs with modified-base calls; piles up 6mA, 5mC and 5hmC calls per position into a bedMethyl file | `modkit pileup <in.bam> <out_bedmethyl.bed> --region chrM --threads <threads>` |
| `ft` (fibertools) | bash | Toolkit for PacBio Fiber-seq data; piles up 6mA calls from PacBio HiFi BAMs | `ft pileup <in.bam> --rgn chrM --m6a --threads <threads> > <out.bed>` |
| `bedtools` | bash | Compares sets of genomic intervals; keeps positions that overlap a region or probe list, extracts sequence | `bedtools intersect -a <in_bedmethyl.bed> -b <positions.bed> -u > <out_bedmethyl.bed>` |
| `conda` | bash | Installs tools into separate environments, so their versions do not clash | `conda activate <env_name>` |
| `srun` | bash | Slurm command that requests resources on a compute node; with `--pty bash` it opens an interactive session | `srun --partition=<partition> --cpus-per-task=<threads> --mem=<memory_gb>G --time=<hh:mm:ss> --pty bash` |
| `tmux` | bash | Keeps terminal sessions running after you disconnect, so long jobs survive a dropped connection | `tmux new -s <session_name>` |
| `kinit` | bash | Requests or renews a Kerberos ticket, the time-limited login needed to reach network drives | `kinit` |
| `pwd` | bash | Prints the folder you are currently in | `pwd` |
| `ls` | bash | Lists the files in a folder; `-lh` adds sizes and dates | `ls -lh <dir>` |
| `cd` | bash | Moves into another folder | `cd <dir>` |
| `mkdir` | bash | Creates a folder; `-p` also creates missing parent folders | `mkdir -p <out_dir>` |
| `cp` | bash | Copies a file; `-r` copies a folder | `cp <in_file> <out_file>` |
| `mv` | bash | Moves or renames a file | `mv <old_name> <new_name>` |
| `rm` | bash | Deletes a file permanently (there is no recycle bin) | `rm <file>` |
| `ln` | bash | Creates a link to a file, so it appears in a second place without being copied | `ln -s <target_file> <link_name>` |
| `cat` | bash | Prints a whole file, or joins several files end to end | `cat <a.txt> <b.txt> > <combined.txt>` |
| `less` | bash | Scrolls through a file one screen at a time; `-S` stops long lines wrapping | `less -S <table.csv>` |
| `tail` | bash | Prints the last lines of a file; `-n +2` prints everything except the header | `tail -n +2 <table.csv>` |
| `column` | bash | Aligns the columns of a delimited file for reading | `column -t -s, <table.csv> \| less -S` |
| `tr` | bash | Replaces or deletes single characters, such as commas to tabs | `tr ',' '\t' < <in.csv> > <out.tsv>` |
| `sed` | bash | Finds and replaces text line by line | `sed 's/<old_text>/<new_text>/g' <in_file> > <out_file>` |
| `paste` | bash | Joins files side by side, line by line | `paste <a.tsv> <b.tsv> > <out.tsv>` |
| `diff` | bash | Shows the lines that differ between two files | `diff <a_file> <b_file>` |
| `find` | bash | Searches a folder tree for files by name, size or date | `find <dir> -name "*.bam"` |
| `basename` | bash | Strips the folder, and optionally the extension, from a path | `basename <in.bam> .bam` |
| `xargs` | bash | Runs a command once for each item it receives from a pipe | `ls <bam_dir>/*.bam \| xargs -n 1 samtools index` |
| `tee` | bash | Shows output on screen and saves it to a file at the same time | `<command> \| tee <log.txt>` |
| `gzip` / `zcat` | bash | Compresses a file; `zcat` prints a compressed file without unpacking it | `zcat <table.csv.gz> \| head` |
| `tar` | bash | Packs a folder into one archive file, or unpacks one | `tar -xzf <archive.tar.gz>` |
| `bgzip` | bash | Compresses a file in blocks so it can be indexed | `bgzip <in.bed>` |
| `tabix` | bash | Indexes a bgzip-compressed, sorted position file and fetches one region from it | `tabix -p bed <in.bed.gz>` |
| `du` | bash | Reports how much disk space a folder uses | `du -sh <dir>` |
| `df` | bash | Reports free space on each drive | `df -h` |
| `chmod` | bash | Changes who can read, write or run a file | `chmod +x <script.sh>` |
| `md5sum` | bash | Computes a checksum to confirm a file was copied or downloaded intact | `md5sum <file>` |
| `wget` | bash | Downloads a file from a web address | `wget <url>` |
| `rsync` | bash | Copies folders, skipping files that are already up to date; can resume | `rsync -av <source_dir>/ <dest_dir>/` |
| `scp` | bash | Copies files between computers over SSH | `scp <file> <user>@<host>:<dest_dir>` |
| `history` | bash | Lists the commands you ran earlier | `history \| grep "modkit pileup"` |
| `man` | bash | Opens the manual for a command | `man sort` |
| `nano` | bash | A simple text editor inside the terminal | `nano <file>` |
| `dorado` | bash | Oxford Nanopore's basecaller; turns raw signal into reads and calls modified bases | `dorado basecaller sup <pod5_dir> --modified-bases 6mA > <calls.bam>` |
| `minimap2` | bash | Aligns long reads to a reference; `-y` carries the modification tags over | `samtools fastq -T MM,ML <calls.bam> \| minimap2 -ax map-ont -y ~/GRCh38.fa - \| samtools sort -o <sorted.bam>` |
| `pbmm2` | bash | PacBio's wrapper around minimap2 for aligning HiFi BAMs | `pbmm2 align ~/GRCh38.fa <in.bam> <out.bam> --sort` |
| `modkit summary` | bash | Reports which modifications a BAM contains and how many calls pass the threshold | `modkit summary <in.bam>` |
| `aligned_bam_to_cpg_scores` | bash | PacBio's pb-CpG-tools; piles up 5mC at CpG sites from HiFi BAMs | `aligned_bam_to_cpg_scores --bam <in.bam> --output-prefix <out_prefix>` |
| `MethylDackel` | bash | Extracts per-CpG methylation from bisulfite-sequencing BAMs | `MethylDackel extract ~/GRCh38.fa <in.bam>` |
| `bismark` | bash | Aligns bisulfite-sequencing reads and calls methylation | `bismark --genome <genome_dir> -1 <R1.fastq.gz> -2 <R2.fastq.gz>` |
| `pandas` | Python | Library for tables (data frames); reads CSVs, filters sites, joins metadata, reshapes per-sample files into one wide matrix | `d = pd.read_csv("<table.csv>")` |
| `matplotlib` | Python | Library for plotting; scatter plots and multi-page PDFs | `plt.scatter(d["<x_column>"], d["<y_column>"])` |
| `numpy` | Python | Library for numeric arrays and fast maths on them | `np.log2(x + 1)` |
| `scipy` | Python | Library of statistical tests and scientific functions | `stats.spearmanr(d["age"], d["<site>"])` |
| `statsmodels` | Python | Library for regression models and multiple-testing correction | `multipletests(pvals, method="fdr_bh")` |
| `scikit-learn` | Python | Library for machine learning, including elastic net and cross-validation | `ElasticNetCV(l1_ratio=0.5, cv=LeaveOneOut()).fit(X, y)` |
| `seaborn` | Python | Library for statistical plots built on matplotlib | `sns.regplot(data=d, x="age", y="<site>")` |
| `pysam` | Python | Library for reading BAM files, including each read's modification calls | `for read in pysam.AlignmentFile("<in.bam>").fetch("chrM"): read.modified_bases` |
| `pyranges` | Python | Library for genomic interval tables, like bedtools inside Python | `pr.read_bed("<in.bed>")` |
| `data.table` | R | Package for fast reading, writing and joining of large tables | `merge(fread("<a.csv>"), fread("<b.csv>"), by = "<key_column>")` |
| `glmnet` | R | Package for lasso, ridge and elastic net regression with built-in cross-validation; builds age predictors | `fit <- cv.glmnet(x, y, alpha = 0.5)` |
| `minfi` | R | Package that reads Illumina methylation array IDAT files, normalises them, and returns beta values | `beta <- getBeta(preprocessNoob(RGset))` |
| `methylclock` | R | Package that applies published epigenetic clocks (Horvath, Hannum, PhenoAge) to a beta matrix | `ages <- DNAmAge(beta)` |
| `ggplot2` | R | Package for plots built up in layers | `ggplot(d, aes(age, <site>)) + geom_point()` |
| `GenomicRanges` | R | Package for genomic intervals and their overlaps | `subsetByOverlaps(a, b)` |
| `rtracklayer` | R | Package that reads and writes BED, GFF and bigWig as GenomicRanges | `import("<in.bed>")` |
| `sesame` | R | Package for methylation arrays; an alternative to minfi that supports EPIC v2 | `betas <- openSesame("<idat_dir>")` |
| `limma` | R | Package for linear models across many features; finds differentially methylated sites | `fit <- eBayes(lmFit(mvals, design))` |
| `missMethyl` | R | Package for gene-set enrichment of array CpGs that corrects for probes per gene | `gometh(sig.cpg = <sig_cpgs>, all.cpg = <all_cpgs>, array.type = "EPIC")` |
| `DSS` | R | Package for differential methylation from sequencing counts | `DMLtest(bs, group1 = <samples_a>, group2 = <samples_b>)` |





