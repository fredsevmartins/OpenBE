test_that("BE AUClast and Cmax agree with independent stratified differences", {
  for(endpoint in c("AUClast","Cmax")) {
    d<-example_dataset(1,endpoint);x<-analyze_2x2(d);ref<-independent_2x2(d)
    for (field in c("gmr","lower","upper","df","p_lower","p_upper"))
      expect_equal(x$summary[[field]],ref[[field]],tolerance=1e-9)
    expect_equal(x$cv_within,ref$cv,tolerance=1e-9)
    expect_equal(x$geometric_lsmeans[1,2]/x$geometric_lsmeans[1,1],ref$gmr,tolerance=1e-9)
    expect_true(all(c("GROUP","SUBJECT(GROUP)","PERIOD","DRUG") %in% rownames(x$anova)))
    expect_equal(as.character(formula(x$model))[3],"subject + period + treatment")
  }
})
test_that("sequence imbalance remains estimable and row ordering is irrelevant", {
  d<-example_dataset(1);d<-d[d$subject!=1, ]
  x<-analyze_2x2(d[nrow(d):1, ]);ref<-independent_2x2(d)
  expect_equal(x$summary$gmr,ref$gmr,tolerance=1e-9)
  expect_equal(x$summary$lower,ref$lower,tolerance=1e-9)
})
test_that("invalid or incomplete conventional input is rejected", {
  d<-example_dataset(1)
  x<-d;x$PK[1]<-0;expect_error(analyze_2x2(x),"positive")
  x<-d;x$PK[1]<--1;expect_error(analyze_2x2(x),"positive")
  x<-d;x$PK[1]<-NA;expect_error(analyze_2x2(x),"Missing PK")
  x<-d;x$treatment[1]<-"X";expect_error(analyze_2x2(x),"Invalid treatment")
  x<-d;x$treatment[1]<-ifelse(x$treatment[1]=="R","T","R");expect_error(analyze_2x2(x),"match sequence")
  expect_error(analyze_2x2(d[-1, ]),"complete")
  expect_error(analyze_2x2(rbind(d,d[1, ])),"Duplicate")
  x<-d;x$period[1]<-1.5;expect_error(analyze_2x2(x),"integer")
})
