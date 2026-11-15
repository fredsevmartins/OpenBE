test_that("parallel analysis agrees with independent pooled t algebra", {
 d<-example_dataset(12);x<-analyze_parallel(d)
 y<-split(log(d$PK),d$treatment);ns<-lengths(y)
 mse<-sum(vapply(y,function(z) sum((z-mean(z))^2),numeric(1)))/(sum(ns)-2)
 se<-sqrt(mse*sum(1/ns));est<-mean(y$T)-mean(y$R);df<-sum(ns)-2
 expect_equal(x$summary$gmr,exp(est),tolerance=1e-12)
 expect_equal(x$summary$lower,exp(est-qt(.95,df)*se),tolerance=1e-12)
 expect_equal(x$summary$upper,exp(est+qt(.95,df)*se),tolerance=1e-12)
 expect_equal(x$cv_between,sqrt(expm1(mse)),tolerance=1e-12)
 expect_equal(x$status,"EXPERIMENTAL")
 expect_error(analyze_parallel(d[1:2, ]),"Invalid treatment|degrees")
})
test_that("balanced Williams contrasts agree with projected normal equations", {
 for(id in 13:14) {
  d<-example_dataset(id);x<-analyze_williams(d);ref<-independent_fixed(d)
  expect_equal(x$summary$gmr,ref$gmr,tolerance=1e-7)
  expect_equal(x$summary$lower,ref$lower,tolerance=1e-7)
  expect_equal(x$summary$upper,ref$upper,tolerance=1e-7)
  expect_true(all(x$summary$p_tost_holm>=pmax(x$summary$p_lower,x$summary$p_upper)))
  expect_equal(x$status,"EXPERIMENTAL")
  alloc<-unique(d[c("sequence","period","treatment")])
  # Each treatment occurs equally often in every period.
  expect_equal(length(unique(as.vector(table(alloc$period,alloc$treatment)))),1L)
  # Each ordered pair of different treatments occurs equally often as neighbors.
  pairs<-unlist(lapply(unique(d$sequence),function(s){z<-strsplit(s,"")[[1]];paste0(head(z,-1),tail(z,-1))}))
  expect_equal(length(unique(as.vector(table(pairs)))),1L)
 }
})
