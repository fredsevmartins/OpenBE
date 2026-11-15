test_that("PKNCA recovers an analytical exponential profile", {
 t<-0:24;conc<-data.frame(subject=1,time=t,concentration=10*exp(-.1*t))
 dose<-data.frame(subject=1,time=0,dose=100)
 intervals<-data.frame(start=0,end=Inf,cmax=TRUE,tmax=TRUE,auclast=TRUE,
  aucinf.obs=TRUE,half.life=TRUE,lambda.z=TRUE,aucpext.obs=TRUE)
 x<-as.data.frame(analyze_nca(conc,dose,intervals,"mg/L","h","mg"))
 v<-setNames(x$PPORRES,x$PPTESTCD)
 expect_equal(unname(v["cmax"]),10,tolerance=1e-8)
 expect_equal(unname(v["tmax"]),0,tolerance=1e-8)
 expect_equal(unname(v["auclast"]),100*(1-exp(-2.4)),tolerance=1e-7)
 expect_equal(unname(v["aucinf.obs"]),100,tolerance=1e-7)
 expect_equal(unname(v["half.life"]),log(2)/.1,tolerance=1e-7)
 expect_equal(unname(v["lambda.z"]),.1,tolerance=1e-8)
 expect_equal(unname(v["aucpext.obs"]),100*exp(-2.4),tolerance=1e-7)
 conc$concentration[2]<-NA
 expect_error(analyze_nca(conc,dose,intervals,"mg/L","h","mg"),"Missing")
})
test_that("a declared repeat-dose interval integrates over tau", {
 # Explicitly simulated steady-state bolus profile; not observed oral data.
 t<-0:12;conc<-data.frame(subject=1,time=t,concentration=10/(1-exp(-1.2))*exp(-.1*t))
 dose<-data.frame(subject=1,time=c(0,12),dose=100)
 intervals<-data.frame(start=0,end=12,auclast=TRUE,cmax=TRUE,tmax=TRUE)
 x<-as.data.frame(analyze_nca(conc,dose,intervals,"mg/L","h","mg"))
 expect_equal(x$PPORRES[x$PPTESTCD=="auclast"],100,tolerance=1e-7)
})
test_that("planning reproduces the documented conventional example and fixed RNG", {
 x<-plan_be();expect_equal(x[["Sample size"]],20)
 expect_true(x[["Achieved power"]]>=.8)
 for(design in c("2x2","2x2x4")) {
   x<-plan_be(design=design)
   expect_equal(PowerTOST::power.TOST(CV=.2,theta0=.95,n=x[["Sample size"]],design=design),
                x[["Achieved power"]],tolerance=1e-9)
 }
 set.seed(91);before<-.Random.seed
 x<-plan_be(cv=.4,design="2x2x4",scaled=TRUE,nsims=1000)
 expect_equal(.Random.seed,before)
 expect_equal(x,plan_be(cv=.4,design="2x2x4",scaled=TRUE,nsims=1000))
 expect_error(plan_be(cv=-.2),"Invalid")
})
