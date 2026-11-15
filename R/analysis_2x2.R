#' Conventional two-sequence two-period bioequivalence
#'
#' Uses BE::test2x2 for the primary ANOVA, geometric LS means and ratio CI.
#' A fixed-subject model supplies residual diagnostics and explicit TOST p-values.
#' Complete subjects are required; sequence sizes may differ. No carryover term
#' is fitted. Natural logarithms and a two-sided 90 percent CI are used.
#' @param data Endpoint data accepted by validate_endpoints().
#' @return List with summary, engine output, model, ANOVA, geometric LS means,
#'   within-subject CV (fraction), and undetermined regulatory assessment.
#' @examples
#' result <- analyze_2x2(example_dataset(1, "AUClast"))
#' result$summary
#' @export
analyze_2x2 <- function(data) {
  restore_session <- analysis_session()
  on.exit(restore_session(), add = TRUE)
  d <- validate_endpoints(data)
  if (!setequal(levels(d$sequence), c("TR", "RT")) ||
      any(table(d$subject) != 2L)) stop("A complete TR/RT 2x2 crossover is required")
  b <- data.frame(SUBJ = as.character(d$subject), GRP = as.character(d$sequence),
                  PRD = as.integer(as.character(d$period)),
                  TRT = as.character(d$treatment), endpoint = d$PK)
  b <- b[order(b$GRP, b$PRD, b$SUBJ), ]
  m <- fixed_model(d)
  fit <- record_fit(BE::test2x2(b, "endpoint"))
  raw <- fit$value
  if (is.null(raw)) stop("BE rejected the data")
  ci <- raw[["90% Confidence Interval of Geometric Mean Ratio (T/R)"]]
  coef <- summary(m)$coefficients["treatmentT", ]
  s <- contrast_result(coef[1], coef[2], stats::df.residual(m))
  # Preserve the primary engine's values rather than silently substituting.
  s[c("lower", "gmr", "upper")] <- as.list(as.numeric(ci[1, ]))
  s$abe_numeric <- numeric_abe(s$lower, s$upper)
  list(summary = s, engine = raw, model = m, data = d,
       anova = raw[[1]], geometric_lsmeans = raw[[3]],
       cv_within = raw[[2]][2, "Within Subject"]/100,
       audit = analysis_audit(d, m, "BE", "Conventional 2x2", "Residual N-2", fit$warnings),
       regulatory = assess_regulatory(s), status = "TESTED_NOT_INDEPENDENTLY_VALIDATED")
}
