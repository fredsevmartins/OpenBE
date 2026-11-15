#' Replicate bioequivalence using Methods A and B
#'
#' Delegates to replicateBE 1.1.3. Method A uses all fixed effects; Method B
#' assumes a common residual variance and a random subject intercept (REML).
#' Treatment-specific CVs are estimated in separate fixed-effect subset models.
#' The engine's historical EMA ABEL classifications are retained as raw output
#' only; they are not an OpenBE regulatory conclusion.
#' @param data Endpoint-level replicate study data.
#' @param missing "error" or explicit "omit"; no imputation is performed.
#' @param option Method B DF: 2 containment (nlme), 1 Satterthwaite (lmerTest),
#'   or 3 Kenward-Roger (lmerTest/pbkrtest).
#' @return List with method comparison, raw engine outputs, diagnostics model,
#'   data and regulatory status. CVs in the comparison are fractions.
#' @export
analyze_replicate <- function(data, missing = c("error", "omit"), option = 2) {
  restore_session <- analysis_session()
  on.exit(restore_session(), add = TRUE)
  if (length(option) != 1 || !option %in% 1:3) stop("option must be 1, 2 or 3")
  d <- validate_endpoints(data, missing = match.arg(missing))
  designs <- list(c("TRTR","RTRT"), c("TRRT","RTTR"), c("TTRR","RRTT"),
    c("TRTR","RTRT","TRRT","RTTR"), c("TRRT","RTTR","TTRR","RRTT"),
    c("TRT","RTR"), c("TRR","RTT"), c("TR","RT","TT","RR"),
    c("TRR","RTR","RRT"), c("TRR","RTR"))
  if (!any(vapply(designs, function(s) setequal(s, levels(d$sequence)), logical(1))))
    stop("Unsupported replicate sequence set")
  # Preflight each estimable variance and treatment comparison.
  m <- fixed_model(d)
  for (tr in c("R", "T")) {
    z <- droplevels(d[d$treatment == tr, ])
    if (any(table(z$subject) > 1)) {
      vm <- stats::lm(log(PK) ~ subject + period, data = z)
      check_df(vm)
    }
  }
  path <- tempfile("openbe-"); dir.create(path)
  on.exit(unlink(path, recursive = TRUE), add = TRUE)
  utils::write.csv(d, file.path(path, "endpoints.csv"), row.names = FALSE)
  args <- list(path.in = path, file = "endpoints", ext = "csv", na = "NA",
               print = FALSE, details = TRUE, ask = FALSE, adjust = FALSE)
  # Method B has no adjust argument.
  fit_a <- record_fit(do.call(replicateBE::method.A, args))
  a <- fit_a$value
  args$adjust <- NULL; args$option <- option
  fit_b <- record_fit(do.call(replicateBE::method.B, args))
  b <- fit_b$value
  diagnostic_fit <- record_fit(if (option == 2) {
    nlme::lme(log(PK) ~ sequence + period + treatment, random = ~1|subject,
      data = d, method = "REML", na.action = stats::na.fail)
  } else {
    lmerTest::lmer(log(PK) ~ sequence + period + treatment + (1|subject), data = d)
  })
  audit <- analysis_audit(d, m, c("replicateBE", "nlme", "lmerTest", "lme4"),
    "Method A fixed effects / Method B random intercept",
    c(A = "Residual", B = c("Satterthwaite", "Containment", "Kenward-Roger")[option]), fit_a$warnings)
  audit$method_B <- fit_diagnostics(diagnostic_fit$value,
    unique(c(fit_b$warnings, diagnostic_fit$warnings)))
  audit$method_B$note <- "Diagnostic refit using the same model specification; primary estimates remain engine outputs"
  extract <- function(x, method) {
    s <- data.frame(method = method, gmr = x[["PE(%)"]]/100,
                    lower = x[["CL.lo(%)"]]/100, upper = x[["CL.hi(%)"]]/100,
                    df = x[["DF"]], cv_wR = x[["CVwR(%)"]]/100,
                    cv_wT = x[["CVwT(%)"]]/100, swR = x[["swR"]])
    s$abe_numeric <- numeric_abe(s$lower, s$upper)
    lim <- abel_limits(s$cv_wR)
    s$abel_lower <- lim[1]; s$abel_upper <- lim[2]
    s$abel_numeric <- numeric_abel(s$lower, s$upper, s$gmr, s$cv_wR)
    s
  }
  list(summary = rbind(extract(a, "A"), extract(b, "B")), engine = list(A = a, B = b),
       model = m, data = d, method_B_option = option, audit = audit,
       models = list(A = m, B = diagnostic_fit$value),
       regulatory = assess_regulatory(extract(a, "A")),
       status = "TESTED_NOT_INDEPENDENTLY_VALIDATED")
}
