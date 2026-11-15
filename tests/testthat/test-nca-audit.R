nca_fixture <- function() {
 list(concentration=data.frame(subject=1,time=0:24,concentration=10*exp(-.1*(0:24))),
 dose=data.frame(subject=1,time=0,dose=100),
 intervals=data.frame(start=0,end=Inf,cmax=TRUE,tmax=TRUE,auclast=TRUE,aucinf.obs=TRUE,half.life=TRUE),
 concentration_unit="mg/L",time_unit="h",dose_unit="mg")
}
test_that("NCA unit conversions preserve physical exposure and terminal estimates", {
 args<-nca_fixture();ref<-do.call(analyze_nca,args)
 args$concentration$concentration<-args$concentration$concentration*1000
 args$concentration$time<-args$concentration$time*60
 args$dose$dose<-args$dose$dose*1000
 args$concentration_unit<-"ng/mL";args$time_unit<-"min";args$dose_unit<-"ug"
 args$target_units<-list(concentration="mg/L",time="h",dose="mg")
 x<-do.call(analyze_nca,args)
 expect_equal(as.data.frame(x)$PPORRES,as.data.frame(ref)$PPORRES,tolerance=1e-8)
 expect_equal(attr(x,"OpenBE_audit")$conversion_factors$time,1/60)
 args$target_units$dose<-"mg/kg"
 expect_error(do.call(analyze_nca,args),"body weight")
 args$target_units$dose<-"mg";args$concentration_unit<-"unknown"
 expect_error(do.call(analyze_nca,args),"Unsupported")
})
test_that("NCA records actual engine terminal windows and exports its audit", {
 x<-do.call(analyze_nca,nca_fixture());audit<-attr(x,"OpenBE_audit")
 tab<-as.data.frame(x);n<-tab$PPORRES[tab$PPTESTCD=="lambda.z.n.points"]
 expect_equal(sum(audit$terminal_points$positive_terminal_point,na.rm=TRUE),as.numeric(n))
 expect_true(all(audit$terminal_points$time[audit$terminal_points$positive_terminal_point]>0))
 expect_true(all(c("r.squared","adj.r.squared","span.ratio") %in% tab$PPTESTCD))
 out<-tempfile();write_nca(x,out)
 expect_true(all(file.exists(file.path(out,c("nca.csv","audit.json","terminal-points.csv","observation-actions.csv")))))
 expect_match(audit$input_sha256,"^[a-f0-9]{64}$")
})
test_that("overlapping intervals retain separate terminal membership", {
 args<-nca_fixture();args$intervals<-rbind(args$intervals,args$intervals)
 args$intervals$end<-c(12,Inf)
 x<-do.call(analyze_nca,args)
 points<-attr(x,"OpenBE_audit")$terminal_points
 expect_equal(sort(unique(points$interval_end)),c(12,Inf))
 expect_equal(nrow(points),50L)
})
test_that("BLQ and missing-value decisions are explicit and traceable", {
 args<-nca_fixture();args$concentration$blq<-FALSE;args$concentration$blq[2]<-TRUE
 args$blq_policy<-"error"
 expect_error(do.call(analyze_nca,args),"BLQ")
 args$blq_policy<-"half_lloq"
 expect_error(do.call(analyze_nca,args),"LLOQ")
 args$lloq<-2
 x<-do.call(analyze_nca,args)
 expect_equal(x$data$conc$data$concentration[2],1)
 expect_match(attr(x,"OpenBE_audit")$observation_actions$action[2],"LLOQ/2")
 args$blq_policy<-"omit"
 x<-do.call(analyze_nca,args)
 expect_equal(attr(x,"OpenBE_audit")$analyzed_rows,24L)
 args$concentration$concentration[3]<-NA;args$missing<-"omit"
 expect_warning(x<-do.call(analyze_nca,args),"omitted")
 expect_equal(attr(x,"OpenBE_audit")$analyzed_rows,23L)
})
