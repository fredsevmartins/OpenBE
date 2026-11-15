#' Numerical conventional ABE interval containment
#' @param lower,upper Ratio confidence limits, unrounded.
#' @param limits Two positive acceptance bounds.
#' @return Logical values. Touching a bound is included; no rounding is applied.
#'   This calculation does not assess regulatory applicability.
#' @export
numeric_abe <- function(lower, upper, limits = c(0.8, 1.25)) {
  if (length(limits) != 2 || any(!is.finite(limits)) ||
      any(limits <= 0) || limits[1] >= limits[2]) stop("Invalid limits")
  if (length(lower) != length(upper) || any(!is.finite(c(lower, upper))) ||
      any(lower <= 0 | upper < lower)) stop("Invalid confidence interval")
  lower >= limits[1] & upper <= limits[2]
}

#' Historical EMA-style expanded limits for computational exploration
#'
#' Uses k=0.760, widening only above CVwR=0.30, capped at CVwR=0.50.
#' These historical constants are not a statement of current eligibility.
#' @param cv_wr Single reference within-subject CV as a fraction.
#' @return Lower and upper ratio limits.
#' @export
abel_limits <- function(cv_wr) {
  if (length(cv_wr) != 1 || !is.finite(cv_wr) || cv_wr < 0) stop("Invalid CVwR")
  if (cv_wr <= 0.30) return(c(lower = 0.8, upper = 1.25))
  exp(c(lower = -1, upper = 1) * 0.760 * sqrt(log1p(min(cv_wr, 0.5)^2)))
}

#' Separate regulatory applicability from statistical calculations
#'
#' No currently effective jurisdiction-specific policy has been qualified for
#' this release. Always returns undetermined, retaining the supplied context
#' and reason. Use numeric_abe() and abel_limits() for transparent calculations.
#' @param statistics Statistical summary retained for traceability.
#' @param guideline Guideline source and version, if supplied.
#' @param endpoint Endpoint name, if known.
#' @return A list with classification, guideline, endpoint and reason.
#' @export
assess_regulatory <- function(statistics, guideline = NA_character_, endpoint = NA_character_) {
  list(classification = "REGULATORY_ASSESSMENT_NOT_DETERMINED",
       guideline = guideline, endpoint = endpoint,
       reason = "Current rule applicability and endpoint eligibility are not qualified in this release",
       statistics = statistics)
}

#' Numerical historical ABEL calculation with the GMR constraint
#' @param lower,upper Single ratio confidence limits.
#' @param gmr Single Test/Reference ratio, contained within its confidence limits.
#' @param cv_wr Reference within-subject CV (fraction).
#' @return Single logical result; no regulatory eligibility is inferred.
#' @export
numeric_abel <- function(lower, upper, gmr, cv_wr) {
  if (length(lower)!=1 || length(upper)!=1 || length(gmr)!=1 ||
      !is.finite(gmr) || gmr<=0 || gmr<lower || gmr>upper) stop("Invalid GMR/interval")
  lim<-abel_limits(cv_wr)
  numeric_abe(lower,upper,lim) && gmr>=.8 && gmr<=1.25
}
