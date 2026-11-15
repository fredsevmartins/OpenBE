#' Noncompartmental analysis with explicit data policies and an audit trail
#'
#' Uses PKNCA; no observed profiles are fabricated from endpoint data. Unit
#' conversions cover declared mass/volume/time units and preserve dose dimension.
#' Terminal-point membership is obtained from PKNCA, not a replacement slope fit.
#' @param concentration Data frame with subject, time, concentration and optional
#'   logical blq. Zero concentrations are also treated as BLQ.
#' @param dose Data frame with subject, time and positive dose.
#' @param intervals PKNCA interval specification in input time units.
#' @param concentration_unit,time_unit,dose_unit Recognized input unit labels.
#' @param options Named PKNCA options. Defaults are recorded in the audit.
#' @param missing Either "error" or explicit "omit" for missing concentrations.
#' @param blq_policy "engine" applies recorded PKNCA zero/BLQ rules; "error",
#'   "omit", "zero" (keep all zero values), or "half_lloq" are explicit alternatives.
#' @param lloq Positive assay limit in input concentration units, required for
#'   half_lloq. No assay limit is inferred from measured values.
#' @param target_units Optional named list with concentration, time and/or dose
#'   labels. Intervals are converted with time; other time-valued options must
#'   already use target units. Dose mg/kg cannot be converted to mg without weight.
#' @return PKNCAresults with OpenBE_units and OpenBE_audit attributes.
#' @export
analyze_nca <- function(concentration, dose, intervals,
                        concentration_unit, time_unit, dose_unit,
                        options = list(auc.method = "lin up/log down"),
                        missing = c("error", "omit"),
                        blq_policy = c("engine", "error", "omit", "zero", "half_lloq"),
                        lloq = NULL, target_units = NULL) {
  restore_session <- analysis_session(); on.exit(restore_session(), add = TRUE)
  missing <- match.arg(missing); blq_policy <- match.arg(blq_policy)
  input_units <- list(concentration = concentration_unit, time = time_unit, dose = dose_unit)
  output_units <- input_units
  if (!is.null(target_units)) {
    if (!is.list(target_units) || is.null(names(target_units)) ||
        any(!names(target_units) %in% names(input_units)) || anyDuplicated(names(target_units)))
      stop("target_units must name concentration, time and/or dose")
    output_units[names(target_units)] <- target_units
  }
  factors <- vapply(names(input_units), function(type)
    unit_factor(input_units[[type]], output_units[[type]], type), numeric(1))
  if (!is.data.frame(concentration) || !is.data.frame(dose) ||
      !all(c("subject","time","concentration") %in% names(concentration)) ||
      !all(c("subject","time","dose") %in% names(dose)) || !nrow(concentration) || !nrow(dose))
    stop("Invalid concentration/dose columns or empty data")
  if (!is.numeric(concentration$time) || !is.numeric(concentration$concentration) ||
      !is.numeric(dose$time) || !is.numeric(dose$dose)) stop("Times, concentrations and doses must be numeric")
  if (anyNA(concentration[c("subject","time")]) || anyNA(dose[c("subject","time","dose")]) ||
      any(!is.finite(c(concentration$time, dose$time, dose$dose))))
    stop("Missing/nonfinite design or dosing observations")
  if (any(!is.finite(concentration$concentration) & !is.na(concentration$concentration)) ||
      any(concentration$concentration < 0, na.rm = TRUE) || any(dose$dose <= 0))
    stop("Invalid concentration or dose")
  if (anyDuplicated(concentration[c("subject","time")]) || anyDuplicated(dose[c("subject","time")]))
    stop("Duplicate subject-time observations")
  original <- concentration
  original_dose <- dose
  concentration$source_row <- seq_len(nrow(concentration))
  flag <- concentration$concentration == 0
  if ("blq" %in% names(concentration)) {
    if (!is.logical(concentration$blq) || anyNA(concentration$blq)) stop("blq must be nonmissing logical values")
    flag <- flag | concentration$blq
  }
  flag[is.na(flag)] <- FALSE
  actions <- data.frame(source_row = concentration$source_row, subject = concentration$subject,
                        time = concentration$time, blq = flag, action = "Retained")
  if (any(flag)) {
    if (blq_policy == "error") stop("BLQ observations require an explicit analysis policy")
    if (blq_policy == "half_lloq") {
      if (length(lloq) != 1 || !is.finite(lloq) || lloq <= 0) stop("A positive explicit LLOQ is required")
      concentration$concentration[flag] <- lloq/2
      actions$action[flag] <- "BLQ replaced by LLOQ/2"
    } else if (blq_policy != "omit") {
      concentration$concentration[flag] <- 0
      actions$action[flag] <- if (blq_policy == "engine") "Zero passed to recorded PKNCA BLQ policy" else "BLQ replaced by zero; retained"
    } else actions$action[flag] <- "BLQ explicitly omitted"
  }
  absent <- is.na(concentration$concentration)
  if (any(absent) && missing == "error") stop("Missing concentration; select missing='omit' explicitly")
  if (any(absent)) {
    actions$action[absent] <- "Missing concentration explicitly omitted"
    warning(sum(absent), " missing concentration observations omitted; no imputation")
  }
  remove <- absent | (flag & blq_policy == "omit")
  concentration <- concentration[!remove, , drop = FALSE]
  if (!nrow(concentration) || !setequal(unique(concentration$subject), unique(dose$subject)))
    stop("Dose and concentration subjects differ after exclusions")
  if (!is.data.frame(intervals) || !all(c("start", "end") %in% names(intervals))) stop("Explicit intervals are required")
  concentration$concentration <- concentration$concentration * factors["concentration"]
  concentration$time <- concentration$time * factors["time"]
  dose$dose <- dose$dose * factors["dose"]; dose$time <- dose$time * factors["time"]
  intervals$start <- intervals$start * factors["time"]; intervals$end <- intervals$end * factors["time"]
  if (blq_policy == "zero") options$conc.blq <- list(first = "keep", middle = "keep", last = "keep")
  effective_options <- utils::modifyList(PKNCA::PKNCA.options(), options)
  terminal_parameters <- c("half.life", "lambda.z", "aucinf.obs", "aucinf.pred", "aucpext.obs", "aucpext.pred")
  requested <- intersect(terminal_parameters, names(intervals))
  terminal <- if (length(requested)) apply(intervals[requested], 1, any) else rep(FALSE, nrow(intervals))
  for (name in c("lambda.z.time.first", "lambda.z.time.last", "lambda.z.n.points", "r.squared", "adj.r.squared", "span.ratio")) {
    if (!name %in% names(intervals)) intervals[[name]] <- FALSE
    intervals[[name]] <- intervals[[name]] | terminal
  }
  co <- PKNCA::PKNCAconc(concentration, concentration ~ time | subject)
  do <- PKNCA::PKNCAdose(dose, dose ~ time | subject)
  fit <- record_fit(PKNCA::pk.nca(PKNCA::PKNCAdata(co, do, intervals = intervals, options = options)))
  result <- fit$value
  points <- terminal_point_audit(result)
  audit <- list(schema_version = "1.0", engine = "PKNCA", engine_version = as.character(utils::packageVersion("PKNCA")),
    input_sha256 = digest::digest(list(original, original_dose), algo = "sha256", serializeVersion = 2),
    input_units = input_units, output_units = output_units, conversion_factors = as.list(factors),
    input_rows = nrow(original), analyzed_rows = nrow(concentration),
    missing_policy = missing, blq_policy = blq_policy, lloq_input_units = lloq,
    observation_actions = actions, options = effective_options, intervals = intervals,
    terminal_points = points, warnings = fit$warnings,
    note = "Terminal-window membership comes from PKNCA; zero values in that window are not log-regression points. Inspect parameter exclusion reasons.")
  attr(result, "OpenBE_units") <- output_units
  attr(result, "OpenBE_audit") <- audit
  result
}

unit_factor <- function(from, to, type) {
  if (length(from) != 1 || length(to) != 1 || is.na(from) || is.na(to) || !nzchar(from) || !nzchar(to))
    stop("Explicit recognized units are required")
  choices <- switch(type,
    concentration = c("mg/L" = 1, "ug/mL" = 1, "ng/mL" = .001, "ug/L" = .001, "ng/L" = 1e-6, "mg/mL" = 1000),
    time = c("h" = 1, "min" = 1/60, "s" = 1/3600),
    dose = c("mg" = 1, "g" = 1000, "ug" = .001, "ng" = 1e-6,
             "mg/kg" = 1, "g/kg" = 1000, "ug/kg" = .001, "ng/kg" = 1e-6))
  if (!from %in% names(choices) || !to %in% names(choices)) stop("Unsupported ", type, " unit; convert explicitly upstream")
  if (type == "dose" && grepl("/kg$", from) != grepl("/kg$", to)) stop("Dose dimensions differ; body weight is required")
  unname(choices[from]/choices[to])
}

# PKNCA's helper permits one terminal window per observation. Split overlapping
# intervals before calling it, retaining distinct interval membership records.
terminal_point_audit <- function(result) {
  windows <- unique(result$result[c("start", "end")])
  points <- lapply(seq_len(nrow(windows)), function(i) {
    z <- result
    keep <- z$result$start == windows$start[i] & z$result$end == windows$end[i]
    z$result <- z$result[keep, , drop = FALSE]
    keep_interval <- z$data$intervals$start == windows$start[i] & z$data$intervals$end == windows$end[i]
    z$data$intervals <- z$data$intervals[keep_interval, , drop = FALSE]
    d <- z$data$conc$data
    member <- PKNCA::get_halflife_points(z)
    d$interval_start <- windows$start[i];d$interval_end <- windows$end[i]
    d$within_engine_terminal_window <- member
    d$positive_terminal_point <- member & d$concentration > 0
    d
  })
  do.call(rbind, points)
}
