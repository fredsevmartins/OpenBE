test_that("analysis estimates do not depend on the caller's contrast options", {
 old <- options();on.exit(options(old))
 baseline <- lapply(c(1,2,12,13), function(id) {
   d <- example_dataset(id)
   if(id==1) analyze_2x2(d)$summary else if(id==2) analyze_replicate(d)$summary else
     if(id==12) analyze_parallel(d)$summary else analyze_williams(d)$summary
 })
 for(contrast in c("contr.sum","contr.helmert")) {
   options(contrasts=c(contrast,"contr.poly"))
   observed <- lapply(c(1,2,12,13), function(id) {
     d<-example_dataset(id)
     if(id==1) analyze_2x2(d)$summary else if(id==2) analyze_replicate(d)$summary else
       if(id==12) analyze_parallel(d)$summary else analyze_williams(d)$summary
   })
   expect_equal(observed,baseline,tolerance=1e-10)
   expect_equal(getOption("contrasts"),c(contrast,"contr.poly"))
 }
})
test_that("all session options are restored after success and errors", {
 old <- options();on.exit(options(old))
 options(digits=7,contrasts=c("contr.sum","contr.poly"))
 before <- options()
 invisible(analyze_replicate(example_dataset(2)))
 expect_identical(options(),before)
 expect_error(analyze_replicate(example_dataset(2),option=9),"option")
 expect_identical(options(),before)
})
test_that("positive residual DF cannot hide a nonestimable treatment contrast", {
 d<-example_dataset(2);d<-d[as.character(d$period) %in% c("1","3") & !is.na(d$PK), ]
 expect_error(analyze_replicate(d),"Nonestimable")
})
test_that("omission cannot hide inconsistent study allocation", {
 d<-example_dataset(2);d$PK[1]<-NA;d$treatment[1]<-"X"
 expect_error(analyze_replicate(d,missing="omit"),"Invalid treatment")
})
test_that("a truncated crossover cannot be silently analyzed as parallel groups", {
 d<-example_dataset(1);d<-d[d$period==1, ]
 expect_error(analyze_parallel(d),"Parallel groups require")
})
test_that("population, provenance and missingness are traceable", {
 d<-example_dataset(2);d$PK[1]<-NA
 expect_warning(x<-analyze_replicate(d,missing="omit"),"omitted")
 expect_equal(x$audit$population$analyzed_rows,nrow(d)-1)
 expect_equal(x$audit$population$exclusions$source_row,1L)
 expect_gt(nrow(x$audit$population$absent_records),0)
 expect_match(x$audit$population$input_sha256,"^[a-f0-9]{64}$")
 expect_equal(x$audit$method_B$fit_method,"REML")
 expect_equal(x$audit$model$fixed_rank,x$audit$model$fixed_columns)
 path<-tempfile();write_analysis(x,path)
 expect_true(all(file.exists(file.path(path,c("audit.json","report.md","excluded-observations.csv","absent-records.csv")))))
 parsed<-jsonlite::read_json(file.path(path,"audit.json"))
 expect_equal(parsed$population$analyzed_rows,nrow(d)-1)
 expect_equal(parsed$model$residual_sd,x$audit$model$residual_sd,tolerance=1e-12)
})
