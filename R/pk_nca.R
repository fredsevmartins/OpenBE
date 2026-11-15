#' Noncompartmental analysis with PKNCA
#'
#' Explicit interval selection and options are required. Zeros are BLQ under
#' PKNCA's rules; negative concentrations, duplicate times, missing observations
#' and undeclared units are rejected here. A validated study-specific BLQ/missing
#' policy must be applied upstream. No endpoint data are turned into profiles.
#' @param concentration Data frame with subject, time and concentration.
#' @param dose Data frame with subject, time and dose, with positive doses.
#' @param intervals PKNCA interval specification with start, end and parameter flags.
#' @param concentration_unit,time_unit,dose_unit Nonempty unit labels.
#' @param options Named options for PKNCAdata (for example auc.method).
#' @return PKNCAresults object with unit labels attached as metadata.
#' @export
analyze_nca <- function(concentration, dose, intervals,
                        concentration_unit, time_unit, dose_unit,
                        options = list(auc.method = "lin up/log down")) {
  units <- c(concentration_unit, time_unit, dose_unit)
  if (length(units) != 3 || anyNA(units) || any(!nzchar(units))) stop("Explicit units are required")
  if (!all(c("subject","time","concentration") %in% names(concentration)) ||
      !all(c("subject","time","dose") %in% names(dose))) stop("Invalid concentration/dose columns")
  if (!is.numeric(concentration$time) || !is.numeric(concentration$concentration) ||
      !is.numeric(dose$time) || !is.numeric(dose$dose)) stop("Times, concentrations and doses must be numeric")
  if (anyNA(concentration) || anyNA(dose) ||
      any(!is.finite(c(concentration$time,concentration$concentration,dose$time,dose$dose))))
    stop("Missing/nonfinite observations require a prespecified upstream policy")
  if (any(concentration$concentration < 0) || any(dose$dose <= 0)) stop("Invalid concentration or dose")
  if (anyDuplicated(concentration[c("subject","time")]) || anyDuplicated(dose[c("subject","time")]))
    stop("Duplicate subject-time observations")
  if (!setequal(unique(concentration$subject), unique(dose$subject))) stop("Dose and concentration subjects differ")
  co <- PKNCA::PKNCAconc(concentration, concentration ~ time | subject)
  do <- PKNCA::PKNCAdose(dose, dose ~ time | subject)
  result <- PKNCA::pk.nca(PKNCA::PKNCAdata(co, do, intervals = intervals, options = options))
  attr(result, "OpenBE_units") <- list(concentration = concentration_unit,
                                      time = time_unit, dose = dose_unit)
  result
}
