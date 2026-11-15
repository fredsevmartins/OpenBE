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
  original <- d
  if (!nrow(d) || anyNA(d[1:4])) stop("Missing design information or empty data")
  if (!is.numeric(d$PK) || any(!is.finite(d$PK) & !is.na(d$PK)))
    stop("PK must be finite numeric values")
  if (any(d$PK <= 0, na.rm = TRUE)) stop("PK endpoints must be positive")
  if (any(!as.character(d$treatment) %in% treatments)) stop("Invalid treatment labels")
  p <- suppressWarnings(as.integer(as.character(d$period)))
  if (anyNA(p) || any(p < 1) || any(as.character(p) != as.character(d$period)))
    stop("Period must be a positive integer")
  if (anyDuplicated(d[c("subject", "period")])) stop("Duplicate subject-period record")
  ns <- vapply(split(as.character(d$sequence), as.character(d$subject)),
               function(x) length(unique(x)), integer(1))
  if (any(ns != 1)) stop("A subject must belong to exactly one sequence")
  expected <- substring(as.character(d$sequence), p, p)
  if (any(expected != as.character(d$treatment))) stop("Treatment does not match sequence/period")
  excluded <- which(is.na(d$PK))
  if (length(excluded)) {
    if (missing == "error") stop("Missing PK; select missing='omit' explicitly")
    warning(length(excluded), " missing PK observations omitted; no imputation")
    d <- d[-excluded, , drop = FALSE]
    p <- p[-excluded]
  }
  if (!nrow(d) || !all(treatments %in% as.character(d$treatment))) stop("Invalid treatment labels after exclusions")
  d$subject <- factor(d$subject)
  d$sequence <- factor(d$sequence)
  d$period <- factor(p)
  d$treatment <- factor(d$treatment, levels = treatments)
  subjects <- unique(original[c("subject", "sequence")])
  planned <- do.call(rbind, lapply(seq_len(nrow(subjects)), function(i) {
    data.frame(subject = as.character(subjects$subject[i]),
      period = seq_len(nchar(as.character(subjects$sequence[i]))))
  }))
  key <- function(z) paste(z$subject, z$period, sep = "\r")
  absent <- planned[!key(planned) %in% key(original), , drop = FALSE]
  exclusions <- original[excluded, c("subject", "sequence", "period", "treatment"), drop = FALSE]
  exclusions$source_row <- excluded
  exclusions$reason <- rep("Missing PK; explicit omission", length(excluded))
  attr(d, "OpenBE_population") <- list(input_rows = nrow(original), analyzed_rows = nrow(d),
    input_subjects = length(unique(original$subject)), analyzed_subjects = nlevels(d$subject),
    retained_source_rows = setdiff(seq_len(nrow(original)), excluded),
    exclusions = exclusions, absent_records = absent, missing_policy = missing,
    sequence_counts = as.data.frame(table(unique(d[c("subject", "sequence")])$sequence)),
    input_sha256 = digest::digest(original, algo = "sha256", serializeVersion = 2))
  d
}

check_df <- function(model, estimable = FALSE) {
  if (!is.finite(stats::df.residual(model)) || stats::df.residual(model) <= 0)
    stop("Insufficient residual degrees of freedom")
  if (estimable) {
    x <- stats::model.matrix(model)
    if (qr(x)$rank < ncol(x) || anyNA(stats::coef(model)))
      stop("Nonestimable model: treatment or design effects are aliased; review missing periods and allocation")
  }
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
  if (nlevels(d$subject) < 2 || nlevels(d$period) < 2)
    stop("Nonestimable crossover model: at least two subjects and periods are required")
  m <- stats::lm(log(PK) ~ subject + period + treatment, data = d,
    contrasts = list(subject = "contr.treatment", period = "contr.treatment", treatment = "contr.treatment"))
  check_df(m, estimable = TRUE)
  m
}
