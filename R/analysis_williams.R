#' Experimental Williams crossover analysis
#'
#' Fits a REML random-intercept model, with sequence, period and treatment fixed.
#' Contrasts are each test minus R on the log scale using emmeans and nlme's
#' containment DF. Reported 90 percent intervals are unadjusted; a separate Holm
#' adjustment is supplied for the family of TOST p-values. Neither adjustment
#' creates a regulatory claim. No differential carryover is modeled.
#' @param data Endpoint data, treatments encoded R, A, B (and C).
#' @return Mixed model, unadjusted contrasts, geometric marginal means and status.
#' @export
analyze_williams <- function(data) {
  restore_session <- analysis_session()
  on.exit(restore_session(), add = TRUE)
  tr <- sort(unique(as.character(data$treatment)))
  if (!"R" %in% tr || !length(tr) %in% c(3L,4L)) stop("Expected three or four treatments including R")
  d <- validate_endpoints(data, treatments = c("R", setdiff(tr, "R")))
  seqs <- if (length(tr) == 3) c("ABR","BRA","RAB","RBA","ARB","BAR") else
    c("ABCR","BRAC","RCBA","CARB")
  if (!setequal(levels(d$sequence), seqs) || any(table(d$subject) != length(tr)))
    stop("Expected a complete balanced Williams sequence structure")
  fit <- record_fit(nlme::lme(log(PK) ~ sequence + period + treatment, random = ~1|subject,
                 data = d, method = "REML", na.action = stats::na.fail))
  m <- fit$value
  em <- emmeans::emmeans(m, ~treatment)
  ctr <- emmeans::contrast(em, "trt.vs.ctrl", ref = 1, adjust = "none")
  cs <- as.data.frame(summary(ctr))
  s <- do.call(rbind, lapply(seq_len(nrow(cs)), function(i) {
    cbind(comparison = cs$contrast[i], contrast_result(cs$estimate[i], cs$SE[i], cs$df[i]))
  }))
  s$p_tost_holm <- stats::p.adjust(pmax(s$p_lower, s$p_upper), method = "holm")
  s$abe_numeric <- numeric_abe(s$lower, s$upper)
  means <- as.data.frame(em); means$geometric_mean <- exp(means$emmean)
  list(summary = s, model = m, data = d, geometric_lsmeans = means,
       audit = analysis_audit(d, m, c("nlme", "emmeans"), "Williams random-intercept",
         "Containment; unadjusted intervals, separate Holm TOST", fit$warnings),
       regulatory = assess_regulatory(s), status = "EXPERIMENTAL")
}
