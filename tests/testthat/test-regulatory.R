test_that("boundary logic uses exact, unrounded inclusive intervals", {
 expect_true(numeric_abe(.8,1.25));expect_false(numeric_abe(.8-1e-12,1.25))
 expect_false(numeric_abe(.8,1.25+1e-12));expect_error(numeric_abe(NA,1.2),"Invalid")
 expect_equal(abel_limits(.1),c(lower=.8,upper=1.25))
 expect_equal(abel_limits(.3),c(lower=.8,upper=1.25))
 expect_equal(abel_limits(.4),exp(c(lower=-1,upper=1)*.760*sqrt(log(1+.4^2))))
 expect_equal(abel_limits(2),abel_limits(.5))
 expect_error(abel_limits(-1),"Invalid")
 # GMR exactly on a conventional boundary is numerically contained only if
 # the entire interval is contained; scaling additionally requires GMR bounds.
 lim<-abel_limits(.4)
 expect_true(numeric_abe(.8,1.25,lim))
 expect_true(numeric_abel(.75,.9,.8,.4))
 expect_true(numeric_abel(1.2,1.3,1.25,.4))
 expect_false(numeric_abel(1.2,1.3,1.25000001,.4))
 expect_false(numeric_abel(.75,.9,.79999999,.4))
 expect_equal(assess_regulatory(data.frame(gmr=1,lower=.9,upper=1.1))$classification,
              "REGULATORY_ASSESSMENT_NOT_DETERMINED")
})
