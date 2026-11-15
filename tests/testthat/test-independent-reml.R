test_that("Method B containment estimates match independent profile REML", {
 for(id in 2:11) {
  d<-example_dataset(id);d<-d[!is.na(d$PK), ]
  reference<-independent_reml(d)
  x<-analyze_replicate(d,option=2)$summary[2, ]
  for(field in c("gmr","lower","upper"))
   expect_equal(x[[field]],reference[[field]],tolerance=2e-5,info=paste(id,field))
  expect_equal(x$df,reference$df,tolerance=1e-8)
 }
})
test_that("Satterthwaite agrees with independent observed-information delta method", {
 # Includes incomplete/unbalanced rds01 and rds05 from different sequence sets.
 for(id in c(2,3,4)) {
  d<-example_dataset(id);d<-d[!is.na(d$PK), ]
  reference<-independent_reml(d,satterthwaite=TRUE)
  x<-analyze_replicate(d,option=1)$summary[2, ]
  expect_equal(x$gmr,reference$gmr,tolerance=2e-5)
  expect_lt(abs(x$df-reference$df),1e-3)
  expect_equal(x$lower,reference$lower,tolerance=2e-5)
 }
})
test_that("balanced complete Kenward-Roger reduces to the exact within-subject case", {
 d<-example_dataset(4)
 expect_true(all(table(d$subject)==4))
 expect_equal(length(unique(as.numeric(table(unique(d[c("subject","sequence")])$sequence)))),1L)
 reference<-independent_reml(d)
 x<-analyze_replicate(d,option=3)$summary[2, ]
 expect_equal(x$gmr,reference$gmr,tolerance=2e-5)
 expect_equal(x$lower,reference$lower,tolerance=2e-5)
 expect_equal(x$df,reference$df,tolerance=1e-6)
})
