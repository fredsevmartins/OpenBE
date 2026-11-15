#' Validate endpoint-level study data
#'
#' Check unique subject-period records, positive endpoints, sequence consistency
#' and treatment allocation. Missing endpoints are rejected by default and may
#' be omitted explicitly without imputation. Subject IDs must be globally unique.
#' @param data Data frame with subject, sequence, period, treatment and PK columns.
#' @param treatments Allowed treatment labels, reference first.
#' @param missing Either "error" or "omit".
#' @return A data frame with factor design columns and numeric PK.
#' @export
validate_endpoints <- function(data, treatments = c("R", "T"),
                               missing = c("error", "omit")) {
  missing <- match.arg(missing)
  required <- c("subject", "sequence", "period", "treatment", "PK")
  if (!is.data.frame(data) || !all(required %in% names(data)))
    stop("Required columns: ", paste(required, collapse = ", "))
  d <- data[required]
  if (!nrow(d) || anyNA(d[1:4])) stop("Missing design information or empty data")
  if (!is.numeric(d$PK) || any(!is.finite(d$PK) & !is.na(d$PK)))
    stop("PK must be finite numeric values")
  if (anyNA(d$PK)) {
    if (missing == "error") stop("Missing PK; select missing='omit' explicitly")
    warning(sum(is.na(d$PK)), " missing PK observations omitted; no imputation")
    d <- d[!is.na(d$PK), ]
  }
  if (!nrow(d) || any(d$PK <= 0)) stop("PK endpoints must be positive")
  if (any(!as.character(d$treatment) %in% treatments) ||
      !all(treatments %in% as.character(d$treatment))) stop("Invalid treatment labels")
  p <- suppressWarnings(as.integer(as.character(d$period)))
  if (anyNA(p) || any(p < 1) || any(as.character(p) != as.character(d$period)))
    stop("Period must be a positive integer")
  if (anyDuplicated(d[c("subject", "period")])) stop("Duplicate subject-period record")
  ns <- vapply(split(as.character(d$sequence), d$subject),
               function(x) length(unique(x)), integer(1))
  if (any(ns != 1)) stop("A subject must belong to exactly one sequence")
  # Parallel sequences are one-character treatment allocations as well.
  expected <- substring(as.character(d$sequence), p, p)
  if (any(expected != as.character(d$treatment))) stop("Treatment does not match sequence/period")
  d$subject <- factor(d$subject)
  d$sequence <- factor(d$sequence)
  d$period <- factor(p)
  d$treatment <- factor(d$treatment, levels = treatments)
  d
}

check_df <- function(model) {
  if (!is.finite(stats::df.residual(model)) || stats::df.residual(model) <= 0)
    stop("Insufficient residual degrees of freedom")
}

# Internal scalar contrast summary on the natural ratio scale.
contrast_result <- function(estimate, se, df, alpha = 0.05) {
  if (any(!is.finite(c(estimate, se, df))) || se <= 0 || df <= 0)
    stop("Nonestimable contrast or insufficient degrees of freedom")
  ci <- exp(estimate + c(-1, 1) * stats::qt(1-alpha, df) * se)
  data.frame(gmr = exp(estimate), lower = ci[1], upper = ci[2],
             log_estimate = estimate, se = se, df = df,
             p_lower = stats::pt((estimate-log(0.8))/se, df, lower.tail = FALSE),
             p_upper = stats::pt((estimate-log(1.25))/se, df),
             alpha = alpha, row.names = NULL)
}

fixed_model <- function(d) {
  # Unique subject factors absorb sequence; equivalent fitted space to
  # sequence + subject nested within sequence + period + treatment.
  m <- stats::lm(log(PK) ~ subject + period + treatment, data = d)
  check_df(m)
  m
}
