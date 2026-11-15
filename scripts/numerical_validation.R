# Independent expected values and explicit external rounded reference values.
source("tests/testthat/helper-independent.R")
rows<-list()
record<-function(design,method,metric,expected,observed,tolerance,source) {
 rows[[length(rows)+1L]]<<-data.frame(design=design,method=method,metric=metric,
  expected=as.numeric(expected),observed=as.numeric(observed),
  difference=as.numeric(observed-expected),tolerance=tolerance,
  outcome=if(abs(observed-expected)<=tolerance) "PASS" else "FAIL",source=source)
}
for(endpoint in c("AUClast","Cmax")) {
 d<-example_dataset(1,endpoint);x<-analyze_2x2(d);ref<-independent_2x2(d)
 for(field in c("gmr","lower","upper","df","p_lower","p_upper"))
 record("01",paste("BE",endpoint),field,ref[[field]],x$summary[[field]],1e-9,"Independent stratified within-subject difference algebra")
 record("01",paste("BE",endpoint),"cv_within",ref$cv,x$cv_within,1e-9,"Independent pooled difference variance / 2")
}
for(id in 2:11) {
 d<-example_dataset(id);d<-d[!is.na(d$PK), ];x<-analyze_replicate(d);ref<-independent_fixed(d)
 for(field in c("gmr","lower","upper","df")) record(sprintf("%02d",id),"Method A",field,
 ref[[field]],x$summary[[field]][1],1e-8,"Subject-centered normal equations; no lm/engine call for expected values")
}
x<-analyze_replicate(na.omit(example_dataset(2)))$summary[2, ]
refs<-c(gmr=1.1573,lower=1.0717,upper=1.2497,cv_wR=.4696,cv_wT=.3516)
for(field in names(refs)) record("02","Method B",field,refs[[field]],x[[field]],.00005,
 "replicateBE 1.1.3 method.B.Rd: EMA rds01 reference example, rounded to 0.01 percentage point; shared engine evidence")
d<-example_dataset(12);x<-analyze_parallel(d);ys<-split(log(d$PK),d$treatment);n<-lengths(ys)
mse<-sum(vapply(ys,function(z)sum((z-mean(z))^2),numeric(1)))/(sum(n)-2)
est<-mean(ys$T)-mean(ys$R);se<-sqrt(mse*sum(1/n));df<-sum(n)-2
refs<-c(gmr=exp(est),lower=exp(est-qt(.95,df)*se),upper=exp(est+qt(.95,df)*se))
for(field in names(refs)) record("12","Pooled parallel",field,refs[[field]],x$summary[[field]],1e-10,"Independent two-group pooled-t algebra")
for(id in 13:14) {
 d<-example_dataset(id);x<-analyze_williams(d);ref<-independent_fixed(d)
 for(j in seq_len(nrow(ref))) for(field in c("gmr","lower","upper"))
 record(sprintf("%02d",id),x$summary$comparison[j],field,ref[[field]][j],x$summary[[field]][j],1e-7,
 "Balanced-design subject-centered normal equations vs random-intercept REML")
}
t<-0:24;conc<-data.frame(subject=1,time=t,concentration=10*exp(-.1*t))
dose<-data.frame(subject=1,time=0,dose=100)
iv<-data.frame(start=0,end=Inf,cmax=TRUE,tmax=TRUE,auclast=TRUE,aucinf.obs=TRUE,
 half.life=TRUE,lambda.z=TRUE,aucpext.obs=TRUE)
x<-as.data.frame(analyze_nca(conc,dose,iv,"mg/L","h","mg"));vals<-setNames(x$PPORRES,x$PPTESTCD)
refs<-c(cmax=10,tmax=0,auclast=100*(1-exp(-2.4)),aucinf.obs=100,half.life=log(2)/.1,
 lambda.z=.1,aucpext.obs=100*exp(-2.4))
for(field in names(refs)) record("NCA","PKNCA exponential synthetic",field,refs[[field]],vals[[field]],1e-7,
 "Independent analytical exponential C(t)=10 exp(-0.1 t); exact integration")
# Independent random-intercept REML, with the implementation separate from all engines.
source("tests/testthat/helper-independent-reml.R")
for(id in 2:11) {
 d<-example_dataset(id);d<-d[!is.na(d$PK), ];ref<-independent_reml(d)
 x<-analyze_replicate(d,option=2)$summary[2, ]
 for(field in c("gmr","lower","upper","df")) record(sprintf("%02d",id),"Method B containment",field,
 ref[[field]],x[[field]],if(field=="df") 1e-8 else 2e-5,
 "Independent Woodbury profile REML; containment within-subject DF (Harville 1977)")
}
for(id in c(2,3,4)) {
 d<-example_dataset(id);d<-d[!is.na(d$PK), ];ref<-independent_reml(d,satterthwaite=TRUE)
 x<-analyze_replicate(d,option=1)$summary[2, ]
 for(field in c("gmr","lower","df")) record(sprintf("%02d",id),"Method B Satterthwaite",field,
 ref[[field]],x[[field]],if(field=="df") 1e-3 else 2e-5,
 "Independent REML observed-information finite-difference delta method; Satterthwaite 1946")
}
d<-example_dataset(4);ref<-independent_reml(d);x<-analyze_replicate(d,option=3)$summary[2, ]
for(field in c("gmr","lower","df")) record("04","Method B Kenward-Roger balanced exact case",field,
 ref[[field]],x[[field]],if(field=="df") 1e-6 else 2e-5,
 "Balanced complete orthogonal within-subject case: exact residual variance and DF; not general incomplete-data KR qualification")
all<-do.call(rbind,rows)
write.csv(all,"docs/validation/numerical-comparisons.csv",row.names=FALSE)
stopifnot(all(all$outcome=="PASS"))
# Hash exact input CSVs, including source-package simulations.
paths<-list.files("inst/extdata",pattern="[.]csv$",full.names=TRUE)
sha<-vapply(paths,function(p)digest::digest(file=p,algo="sha256"),character(1))
write.csv(data.frame(file=paths,sha256=sha),"docs/validation/dataset-sha256.csv",row.names=FALSE)
meta<-read.csv("inst/extdata/designs.csv",stringsAsFactors=FALSE)
meta$implemented<-TRUE
meta$executed<-vapply(meta$directory,function(p)length(list.files(file.path("examples",p,"outputs"),pattern="summary.csv",recursive=TRUE))>0,logical(1))
meta$independently_validated<-FALSE
meta$validation_status<-ifelse(meta$id<=11,"TESTED_NOT_INDEPENDENTLY_VALIDATED","EXPERIMENTAL")
meta$tutorial<-file.exists(file.path("docs/tutorials",paste0(meta$directory,".qmd")))
meta$figure_files<-vapply(meta$directory,function(p)length(list.files(file.path("examples",p,"outputs"),pattern="[.](png|pdf)$",recursive=TRUE)),integer(1))
write.csv(meta,"docs/validation/design-status.csv",row.names=FALSE)
summary<-read.csv("docs/validation/test-summary.csv")
report<-c("# Scientific validation report", "",
 "Scope: research implementation and targeted numerical verification, not a blanket software/regulatory qualification.","",
 sprintf("This invocation executed %d test blocks and %d passing expectations; failures=%d, errors=%d, skipped=%d.",
 nrow(summary),sum(summary$passed),sum(summary$failed),sum(summary$error),sum(summary$skipped)),
 sprintf("All %d recorded numerical comparisons passed their explicit absolute tolerances.",nrow(all)),"",
 "## Evidence", "",
 "- [Test outcome counts](test-summary.csv), [machine-readable test results](test-results.rds), [session information](sessionInfo.txt).",
 "- [Expected/observed/difference/tolerance/source per numerical check](numerical-comparisons.csv).",
 "- [Per-design completion and validation status](design-status.csv).",
 "- [SHA-256 input fingerprints](dataset-sha256.csv).", "",
 "## Interpretation and limitations", "",
 "Design 01: BE estimates, both endpoints, CV, TOST p-values and DF agree with independent closed-form sequence-stratified subject differences. This is targeted analytical verification on the supplied simulated data, not comprehensive clinical validation.","",
 "Designs 02–11: Method A GMR, CI and DF agree with an independent subject-centered normal-equation implementation on each design's reference data. Separate within-treatment variance estimates are checked in the test suite using projected residual sums of squares. This supports the selected calculations, not every missingness/covariance/outlier pattern.","",
 "Method B: an independent Woodbury/profile-REML implementation cross-checks GMR, CI and containment DF for all ten replicate designs. Independent observed-information/delta-method Satterthwaite calculations check three source datasets, including incomplete/unbalanced rds01. Kenward-Roger is checked against the exact complete balanced orthogonal case. General incomplete/unbalanced Kenward-Roger still requires an external qualified reference. EMA rds01 rounded help-example values remain separately identified shared-engine corroboration. Tolerances and observed differences are recorded per metric.","",
 "Design 12: independent pooled-t algebra corroborates the equal-variance parallel model. Designs 13–14: balanced random-intercept contrasts match fixed-subject normal equations; period and first-order carryover balance are tested. These custom workflows remain EXPERIMENTAL pending broader external reference qualification, missing-data studies and covariance sensitivity.","",
 "NCA: a separately labeled analytical exponential profile checks Cmax, Tmax, AUClast, AUCinf, lambda.z, half-life and extrapolated AUC percentage. A synthetic repeat-dose interval verifies tau integration. The observed Theoph example is a demonstration, not a complete validation of automated terminal-phase selection or clinical BLQ policy.","",
 "Planning: conventional output is cross-checked with power.TOST; scaled output is reproducible with the stated seed but is Monte Carlo and not independently qualified.","",
 "Regression tests additionally verify contrast-setting invariance, complete session-option restoration, aliased effects despite positive residual DF, source-row exclusions, input fingerprints, explicit BLQ policies, dimension-safe unit conversions, overlapping NCA intervals, actual engine terminal-point membership and fail-closed regulatory rule selection. Boundary tests cover CI limits, scaling onset/cap, invalid labels, nonpositive endpoints, missing observations, unequal sequence sizes, insufficient DF and nonestimability. No assertions are disabled and no zero-test run is accepted.","",
 "## Classification", "",
 "No complete analytical implementation is labeled VALIDATED. Designs 01–11 are TESTED_NOT_INDEPENDENTLY_VALIDATED; 12–14 are EXPERIMENTAL. FAIL is an individual numerical check outcome; FAILED is reserved for an implementation failing its required checks. NOT_IMPLEMENTED is used for unimplemented regulatory qualification (current rule selection/eligibility) and FDA RSABE. A script running successfully does not upgrade these statuses.","",
 "## Regulatory and publication limits", "",
 "Current official guidance retrieval was blocked by network policy. All shipped regulatory rules remain unqualified and abstain. A caller-attested custom registry can exercise the five-stage assessment pipeline; synthetic test registries are not official policy qualification. Numerical ABE/legacy ABEL flags must not be interpreted as current regulatory eligibility. Local tests and rendering do not establish remote GitHub Actions success or GitHub Pages deployment.")
writeLines(report,"docs/validation/VALIDATION_REPORT.md")
