library(OpenBE)
# Test files are also run by R CMD check. The RDS/CSV store this invocation only.
dir.create("docs/validation",recursive=TRUE,showWarnings=FALSE)
r <- testthat::test_local(reporter="summary",stop_on_failure=TRUE)
saveRDS(r,"docs/validation/test-results.rds")
t <- as.data.frame(r)
write.csv(t[c("file","test","nb","failed","skipped","error","warning","passed")],
          "docs/validation/test-summary.csv",row.names=FALSE)
writeLines(capture.output(sessionInfo()),"docs/validation/sessionInfo.txt")
source("scripts/numerical_validation.R")
