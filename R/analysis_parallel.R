#' Experimental equal-variance parallel-group analysis
#'
#' Fits log(PK) ~ treatment to independent subjects. Assumes a common
#' between-subject log variance; this is not a Welch analysis.
#' @param data Endpoint data; one period and one observation per subject.
#' @return Model, ratio summary, between-subject CV and regulatory status.
#' @export
analyze_parallel <- function(data) {
  restore_session <- analysis_session()
  on.exit(restore_session(), add = TRUE)
  d <- validate_endpoints(data)
  if (!setequal(levels(d$sequence), c("R", "T")))
    stop("Parallel groups require sequences labeled R and T; crossover sequences are not parallel groups")
  if (any(table(d$subject) != 1) || any(as.character(d$period) != "1"))
    stop("Parallel analysis requires one observation per independent subject")
  m <- stats::lm(log(PK) ~ treatment, d, contrasts = list(treatment = "contr.treatment")); check_df(m, estimable = TRUE)
  co <- summary(m)$coefficients["treatmentT", ]
  s <- contrast_result(co[1], co[2], stats::df.residual(m))
  s$abe_numeric <- numeric_abe(s$lower, s$upper)
  list(summary = s, model = m, data = d,
       cv_between = sqrt(expm1(stats::sigma(m)^2)),
       audit = analysis_audit(d, m, "stats", "Equal-variance parallel", "Pooled N_T+N_R-2",
         covariance = "Common between-subject log variance"),
       regulatory = assess_regulatory(s), status = "EXPERIMENTAL")
}
