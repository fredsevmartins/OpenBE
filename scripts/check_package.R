# Portable runner: no fixed version in the tarball name and no shell pipelines.
stopifnot(file.exists("DESCRIPTION"))
d <- read.dcf("DESCRIPTION")
r <- file.path(R.home("bin"), "R")
status <- system2(r, c("CMD", "build", "."))
if (status != 0) quit(status = status)
tarball <- paste0(d[1,"Package"], "_", d[1,"Version"], ".tar.gz")
status <- system2(r, c("CMD", "check", "--no-manual", shQuote(tarball)))
quit(status = status)
