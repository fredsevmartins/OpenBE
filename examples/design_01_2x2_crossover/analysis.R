# Execute: Rscript examples/design_01_2x2_crossover/analysis.R
args <- commandArgs(trailingOnly=FALSE)
file <- sub("^--file=", "", args[grepl("^--file=",args)][1])
if (is.na(file)) stop("Run this example with Rscript")
example_dir <- dirname(normalizePath(file))
root <- normalizePath(file.path(example_dir,"../.."))
source(file.path(root,"scripts/example_helpers.R"))
run_design(1,example_dir)
