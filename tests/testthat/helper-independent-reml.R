# Independent compound-symmetry REML implementation for numerical verification.
# Uses Woodbury inversion and profile restricted likelihood, never nlme/lme4,
# replicateBE or an OpenBE analysis function. Not an alternative public engine.
independent_reml <- function(data, satterthwaite = FALSE) {
  d <- data[!is.na(data$PK), ]
  d$sequence <- factor(d$sequence); d$period <- factor(d$period)
  d$treatment <- factor(d$treatment, levels = c("R", "T"))
  X <- model.matrix(~sequence + period + treatment, d,
    contrasts.arg = list(sequence = "contr.treatment", period = "contr.treatment", treatment = "contr.treatment"))
  y <- log(d$PK); subject <- factor(d$subject); id <- as.integer(subject)
  ni <- as.numeric(table(subject)); n <- length(y); p <- ncol(X)
  j <- which(colnames(X) == "treatmentT")
  if (qr(X)$rank != p || n <= p) stop("Independent reference design is not estimable")
  weighted <- function(x, rho) {
    if (is.null(dim(x))) x <- matrix(x, ncol = 1)
    totals <- rowsum(x, subject, reorder = FALSE)
    # rowsum(reorder=FALSE) follows first appearance, which need not be lexical.
    totals <- totals[match(levels(subject), rownames(totals)), , drop = FALSE]
    x - (rho/(1+rho*ni))[id] * totals[id, , drop = FALSE]
  }
  components <- function(rho) {
    wx <- weighted(X, rho); wy <- weighted(y, rho)
    information <- crossprod(X, wx)
    inv <- solve(information)
    beta <- drop(inv %*% crossprod(X, wy))
    e <- y - drop(X %*% beta)
    sse <- sum(e * weighted(e, rho))
    list(inv = inv, beta = beta, sse = sse,
      logdet = sum(log1p(rho*ni)) + as.numeric(determinant(information, logarithm = TRUE)$modulus))
  }
  objective <- function(logrho) {
    z <- components(exp(logrho))
    z$logdet + (n-p)*log(z$sse/(n-p))
  }
  opt <- optimize(objective, interval = c(-18, 18), tol = 1e-10)
  rho <- exp(opt$minimum)
  z <- components(rho)
  boundary <- components(0)
  if (boundary$logdet + (n-p)*log(boundary$sse/(n-p)) < opt$objective) {rho <- 0; z <- boundary}
  se2 <- z$sse/(n-p)
  variance <- se2*z$inv[j,j]
  df <- n - length(ni) - (nlevels(d$period)-1) - 1
  if (satterthwaite) {
    if (rho <= 1e-7) stop("Satterthwaite reference is not qualified at the variance boundary")
    theta <- log(c(se2*rho, se2))
    nll <- function(a) {
      zz <- components(exp(a[1]-a[2]))
      .5*(zz$logdet + (n-p)*a[2] + zz$sse/exp(a[2]))
    }
    vfun <- function(a) exp(a[2])*components(exp(a[1]-a[2]))$inv[j,j]
    h <- 1e-3
    H <- matrix(0,2,2); grad <- numeric(2)
    for (k in 1:2) {
      step <- numeric(2);step[k] <- h
      H[k,k] <- (nll(theta+step)-2*nll(theta)+nll(theta-step))/h^2
      grad[k] <- (vfun(theta+step)-vfun(theta-step))/(2*h)
    }
    a<-c(h,0);b<-c(0,h)
    H[1,2]<-H[2,1]<-(nll(theta+a+b)-nll(theta+a-b)-nll(theta-a+b)+nll(theta-a-b))/(4*h^2)
    df <- drop(2*variance^2/(t(grad) %*% solve(H, grad)))
  }
  est <- unname(z$beta[j]); se <- unname(sqrt(variance))
  list(gmr = exp(est), lower = exp(est-qt(.95,df)*se), upper = exp(est+qt(.95,df)*se),
       df = df, log_estimate = est, se = se, residual_variance = se2,
       subject_variance = se2*rho)
}
