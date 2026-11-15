# Execute: Rscript examples/design_07_three_period_full_replicate/analysis.R
args <- commandArgs(trailingOnly=FALSE)
file <- sub("^--file=", "", args[grepl("^--file=",args)][1])
if (is.na(file)) stop("Run this example with Rscript")
example_dir <- dirname(normalizePath(file))
root <- normalizePath(file.path(example_dir,"../.."))
source(file.path(root,"scripts/example_helpers.R"))
run_design(7,example_dir)
