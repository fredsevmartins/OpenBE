# Network-backed frozen-lock restore in a new library, with cache reuse disabled.
# Never counts a blocked network operation as a successful restore.
stopifnot(file.exists("renv.lock"))
if (!requireNamespace("renv",quietly=TRUE)) stop("Install renv before this check")
Sys.setenv(RENV_CONFIG_CACHE_ENABLED = "FALSE")
lock <- renv::lockfile_read("renv.lock")
repos <- lock$R$Repositories
repo <- if (is.data.frame(repos)) repos$URL[[1]] else if (is.list(repos[[1]])) repos[[1]]$URL else unname(repos[[1]])
probe <- tempfile(fileext=".gz")
tryCatch(utils::download.file(paste0(repo,"/src/contrib/PACKAGES.gz"),probe,quiet=TRUE),
 error=function(e)stop("Clean restore blocked before installation: ",conditionMessage(e)))
unlink(probe)
lib <- tempfile("openbe-clean-library-");dir.create(lib)
renv::restore(library=lib,prompt=FALSE,clean=TRUE)
installed <- installed.packages(lib.loc=c(lib,.Library))
for (name in names(lock$Packages)) {
 expected <- lock$Packages[[name]]$Version
 if (!name %in% rownames(installed) || installed[name,"Version"] != expected)
  stop("Frozen version not restored: ",name)
}
status <- system2(file.path(R.home("bin"),"R"),c("CMD","INSTALL",paste0("--library=",shQuote(lib)),"."))
if(status != 0)quit(status=status)
# Verify the installed package in a separate R process with the restored library.
smoke <- tempfile(fileext=".R")
writeLines(c(paste0(".libPaths(c(",deparse(lib),",.Library), include.site=FALSE)"),
 "library(OpenBE)","stopifnot(is.finite(analyze_2x2(example_dataset(1))$summary$gmr))",
 "stopifnot(all(is.finite(analyze_replicate(example_dataset(2))$summary$gmr)))",
 "cat('Fresh locked-library installation and functional checks passed\\n')"),smoke)
status<-system2(file.path(R.home("bin"),"Rscript"),shQuote(smoke))
if(status!=0)quit(status=status)
writeLines(capture.output(sessionInfo()),"clean-restore-session.txt")
cat("Verified",length(lock$Packages),"exact restored package versions in",lib,"\n")
