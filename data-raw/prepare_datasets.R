# Run from the repository root. Original datasets retain their source licenses.
map <- c(1,5,28,23,24,3,10,27,2,22)
for (i in seq_along(map)) {
  d <- getExportedValue("replicateBE", sprintf("rds%02d",map[i]))
  utils::write.csv(d, sprintf("inst/extdata/design_%02d.csv",i+1),row.names=FALSE)
}
b <- BE::NCAResult4BE
for (endpoint in c("AUClast","Cmax")) {
 d <- data.frame(subject=b$SUBJ,sequence=b$GRP,period=b$PRD,treatment=b$TRT,PK=b[[endpoint]])
 utils::write.csv(d,paste0("inst/extdata/design_01_",endpoint,".csv"),row.names=FALSE)
}
simulate_design <- function(sequences, n_per_sequence, seed, sd_subject = .3, sd_error = .2) {
 set.seed(seed)
 out <- list(); id <- 0L
 for (s in sequences) for (j in seq_len(n_per_sequence)) {
   id <- id+1L; b <- rnorm(1,0,sd_subject); tr <- strsplit(s,"")[[1]]
   period <- seq_along(tr)
   effects <- c(R=0,T=log(.95),A=log(.95),B=log(1.03),C=log(.98))
   # log PK = log(100) + treatment + period + subject + residual.
   out[[id]] <- data.frame(subject=id,sequence=s,period=period,treatment=tr,
       PK=exp(log(100)+effects[tr]+.02*(period-1)+b+rnorm(length(tr),0,sd_error)))
 }
 do.call(rbind,out)
}
# Parallel: all variation is between subjects; the total log SD is sqrt(.3^2+.2^2).
synthetic <- list(
 simulate_design(c("T","R"),30,12012),
 simulate_design(c("ABR","BRA","RAB","RBA","ARB","BAR"),6,13013),
 simulate_design(c("ABCR","BRAC","RCBA","CARB"),8,14014))
for (i in seq_along(synthetic)) utils::write.csv(synthetic[[i]],
 sprintf("inst/extdata/design_%02d.csv",i+11),row.names=FALSE)
utils::write.csv(datasets::Theoph,"inst/extdata/theoph.csv",row.names=FALSE)
