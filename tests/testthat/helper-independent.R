# Independent, closed-form stratified within-subject differences for 2x2.
independent_2x2 <- function(d) {
  ids <- unique(d$subject)
  diffs <- lapply(ids,function(id) {
    z<-d[d$subject==id, ];c(sequence=as.character(z$sequence[1]),
                           difference=log(z$PK[z$treatment=="T"])-log(z$PK[z$treatment=="R"]))
  })
  z<-as.data.frame(do.call(rbind,diffs));z$difference<-as.numeric(z$difference)
  splitdiff<-split(z$difference,z$sequence)
  ns<-lengths(splitdiff);av<-vapply(splitdiff,mean,numeric(1))
  df<-sum(ns)-2
  pooled<-sum(vapply(splitdiff,function(x) sum((x-mean(x))^2),numeric(1)))/df
  est<-mean(av);se<-sqrt(pooled*sum(1/ns))/2
  list(gmr=exp(est),lower=exp(est-qt(.95,df)*se),upper=exp(est+qt(.95,df)*se),
       cv=sqrt(expm1(pooled/2)),df=df,
       p_lower=pt((est-log(.8))/se,df,lower.tail=FALSE),p_upper=pt((est-log(1.25))/se,df))
}

# Independent normal equations, with subject means projected out first.
# Does not call lm(), emmeans(), BE or replicateBE.
independent_fixed <- function(d) {
  y<-log(d$PK)
  subject<-as.character(d$subject)
  period<-factor(d$period)
  tr<-factor(d$treatment,levels=c("R",sort(setdiff(unique(as.character(d$treatment)),"R"))))
  X<-cbind(model.matrix(~period)[,-1,drop=FALSE],model.matrix(~tr)[,-1,drop=FALSE])
  centered<-apply(X,2,function(x) x-ave(x,subject,FUN=mean))
  yc<-y-ave(y,subject,FUN=mean)
  inv<-solve(crossprod(centered));beta<-drop(inv%*%crossprod(centered,yc))
  df<-nrow(d)-length(unique(subject))-ncol(X)
  mse<-sum((yc-centered%*%beta)^2)/df
  j<-(nlevels(period)):(ncol(X))
  data.frame(gmr=exp(beta[j]),lower=exp(beta[j]-qt(.95,df)*sqrt(diag(inv)[j]*mse)),
     upper=exp(beta[j]+qt(.95,df)*sqrt(diag(inv)[j]*mse)),df=df,mse=mse,row.names=NULL)
}
