test_that("all ten replicate designs agree with independent fixed-effect calculations", {
 for(id in 2:11) {
  d<-example_dataset(id);d<-d[!is.na(d$PK), ]
  x<-analyze_replicate(d);ref<-independent_fixed(d)
  expect_equal(x$summary$gmr[1],ref$gmr,tolerance=1e-8,info=paste("design",id))
  expect_equal(x$summary$lower[1],ref$lower,tolerance=1e-8)
  expect_equal(x$summary$upper[1],ref$upper,tolerance=1e-8)
  expect_equal(x$summary$df[1],ref$df,tolerance=1e-8)
  # Within-treatment differencing projects out the subject intercept;
  # normal equations estimate the remaining period adjustment.
  for(tr in c("R","T")) {
    z<-d[d$treatment==tr, ];counts<-table(z$subject)
    if (!any(counts>1)) {
      expect_true(is.na(x$summary$cv_wT[1]))
    } else {
      y<-log(z$PK);sub<-as.character(z$subject)
      P<-model.matrix(~factor(period),z)[,-1,drop=FALSE]
      Pc<-apply(P,2,function(v) v-ave(v,sub,FUN=mean))
      yc<-y-ave(y,sub,FUN=mean);q<-qr(Pc)
      rss<-sum(qr.resid(q,yc)^2)
      df<-nrow(z)-length(unique(sub))-q$rank
      cv<-sqrt(expm1(rss/df))
      field<-if(tr=="R") "cv_wR" else "cv_wT"
      expect_equal(x$summary[[field]][1],cv,tolerance=1e-8)
    }
  }
 }
})
test_that("EMA rds01 rounded reference example is reproduced by Method B", {
 x<-analyze_replicate(example_dataset(2))$summary[2, ]
 # Expected results transcribed from replicateBE 1.1.3 method.B.Rd example.
 expect_lte(abs(100*x$gmr-115.73),0.005)
 expect_lte(abs(100*x$lower-107.17),0.005)
 expect_lte(abs(100*x$upper-124.97),0.005)
 expect_lte(abs(100*x$cv_wR-46.96),0.005)
 expect_lte(abs(100*x$cv_wT-35.16),0.005)
})
test_that("Method B backend and DF options match explicitly fitted models", {
 d<-example_dataset(2);d<-d[!is.na(d$PK), ];z<-validate_endpoints(d)
 m<-nlme::lme(log(PK)~sequence+period+treatment,random=~1|subject,data=z,method="REML")
 x<-analyze_replicate(d,option=2)
 expect_equal(x$summary$df[2],summary(m)$tTable["treatmentT","DF"])
 expect_equal(x$summary$gmr[2],exp(nlme::fixef(m)["treatmentT"]),ignore_attr=TRUE)
 for(option in c(1,3)) {
   y<-analyze_replicate(d,option=option)
   expect_true(all(is.finite(y$summary$lower)))
   expect_true(y$summary$df[2]>0)
 }
})
test_that("missingness, nonestimability and invalid designs are explicit", {
 d<-example_dataset(2);d$PK[1]<-NA_real_
 expect_error(analyze_replicate(d),"Missing PK")
 expect_warning(x<-analyze_replicate(d,missing="omit"),"omitted")
 expect_true(all(is.finite(x$summary$gmr)))
 expect_error(analyze_replicate(example_dataset(1)),"Unsupported")
 expect_error(analyze_replicate(d,option=9),"option")
 tiny<-subset(example_dataset(4),subject %in% unique(subject)[1:2])
 expect_error(analyze_replicate(tiny),"Insufficient|Nonestimable|Unsupported")
})
