# Run from repository root; each example also works as an independent Rscript.
stopifnot(file.exists("DESCRIPTION"))
meta <- read.csv("inst/extdata/designs.csv",stringsAsFactors=FALSE)
for (directory in meta$directory) {
 script <- file.path("examples",directory,"analysis.R")
 status <- system2(file.path(R.home("bin"),"Rscript"),script)
 if (status != 0) stop("Example failed: ",script)
}
source("scripts/run_nca.R")
source("scripts/run_planning.R")
