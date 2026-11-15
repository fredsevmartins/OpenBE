qualified_fixture <- function(method="conventional_abe") {
 # Synthetic qualification metadata tests the control flow, not an actual policy.
 r<-regulatory_rules()[1,,drop=FALSE]
 r$rule_id<-"SYNTHETIC_TEST_ONLY";r$jurisdiction<-"TEST";r$method<-method
 r$source_url<-"https://example.invalid/synthetic-policy";r$source_sha256<-paste(rep("a",64),collapse="")
 r$verified_on<-"2025-01-01";r$effective_from<-"2025-01-01";r$effective_until<-"2030-01-01"
 r$version<-"SYNTHETIC 1";r$verification_status<-"VERIFIED";r$method_status<-"QUALIFIED"
 r$endpoints<-if(method=="legacy_abel") "Cmax" else "Cmax|AUClast"
 r
}
test_that("all built-in rules abstain until verified and qualified", {
 s<-data.frame(gmr=1,lower=.9,upper=1.1)
 for(id in regulatory_rules()$rule_id) {
  x<-assess_regulatory(s,endpoint="Cmax",rule_id=id,jurisdiction="ICH",formulation="IR",eligibility_confirmed=TRUE,confidence_level=.9)
  expect_equal(x$classification,"REGULATORY_ASSESSMENT_NOT_DETERMINED")
  expect_null(x$limits)
  expect_equal(length(x$stages),5L)
 }
})
test_that("a caller-attested fixture follows all five assessment stages", {
 r<-qualified_fixture();s<-data.frame(gmr=1,lower=.9,upper=1.1)
 args<-list(statistics=s,endpoint="Cmax",rule_id=r$rule_id,jurisdiction="TEST",formulation="IR",
  eligibility_confirmed=TRUE,confidence_level=.9,assessment_date=as.Date("2026-01-01"),rules=r)
 x<-do.call(assess_regulatory,args)
 expect_equal(x$classification,"REGULATORY_CRITERIA_MET")
 expect_true(x$eligibility$analyst_attested)
 args$statistics$lower<-.79
 expect_equal(do.call(assess_regulatory,args)$classification,"REGULATORY_CRITERIA_NOT_MET")
 args$eligibility_confirmed<-NA
 expect_equal(do.call(assess_regulatory,args)$classification,"REGULATORY_ASSESSMENT_NOT_DETERMINED")
 args$eligibility_confirmed<-TRUE;args$assessment_date<-as.Date("2031-01-01")
 expect_equal(do.call(assess_regulatory,args)$classification,"REGULATORY_ASSESSMENT_NOT_DETERMINED")
})
test_that("ABEL cannot be applied to AUC or an unqualified replicate estimate", {
 r<-qualified_fixture("legacy_abel");s<-data.frame(gmr=1,lower=.76,upper=1.3)
 args<-list(statistics=s,endpoint="Cmax",rule_id=r$rule_id,jurisdiction="TEST",formulation="IR",
  eligibility_confirmed=TRUE,reference_replicated=TRUE,reliable_variance=TRUE,
  cv_wr=.4,confidence_level=.9,assessment_date=as.Date("2026-01-01"),rules=r)
 expect_equal(do.call(assess_regulatory,args)$classification,"REGULATORY_CRITERIA_MET")
 args$endpoint<-"AUClast"
 expect_equal(do.call(assess_regulatory,args)$classification,"REGULATORY_ASSESSMENT_NOT_DETERMINED")
 args$endpoint<-"Cmax";args$reference_replicated<-FALSE
 expect_equal(do.call(assess_regulatory,args)$classification,"REGULATORY_ASSESSMENT_NOT_DETERMINED")
})
