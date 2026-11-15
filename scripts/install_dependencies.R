# Standard development installation. Use the lockfile instead of changing pins.
options(repos=c(CRAN="https://cloud.r-project.org"))
if (!requireNamespace("renv",quietly=TRUE)) install.packages("renv")
if (!file.exists("renv.lock")) stop("Run from the repository root containing renv.lock")
renv::activate()
renv::restore(prompt=FALSE)
