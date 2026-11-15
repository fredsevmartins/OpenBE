#' Inspect the versioned regulatory rule register
#'
#' No shipped rule is currently qualified. The register records the official
#' source URL, version/effective-date fields and blocked verification explicitly.
#' No rule is enabled by the mere existence of a numerical implementation.
#' @return Data frame of rule metadata, without a regulatory endorsement.
#' @export
regulatory_rules <- function() {
  utils::read.csv(system.file("extdata", "regulatory-rules.csv", package = "OpenBE"),
                  stringsAsFactors = FALSE, colClasses = "character", na.strings = "")
}

#' Assess a selected, versioned regulatory rule with explicit eligibility
#'
#' Separates statistics, source/rule selection, eligibility, numerical limits
#' and classification. All shipped rules abstain pending official-source and
#' method qualification. Supplying a custom register is a caller attestation of
#' qualification; OpenBE does not verify a document by trusting its metadata.
#' @param statistics Single-comparison ratio summary with gmr, lower and upper.
#' @param guideline Optional legacy source metadata when no rule is selected.
#' @param endpoint Endpoint identifier, such as Cmax or AUClast.
#' @param rule_id Unique registered rule identifier; default abstains.
#' @param jurisdiction,formulation Explicit context matching the rule.
#' @param eligibility_confirmed Explicit analyst confirmation of study-specific
#'   applicability, including product-specific exclusions and prespecified SAP.
#' @param reference_replicated,reliable_variance Explicit confirmations for ABEL.
#' @param cv_wr Reference within-subject CV, required for ABEL.
#' @param confidence_level Stated confidence level; must be 0.90.
#' @param assessment_date Date on which the effective window is evaluated.
#' @param rules Register from regulatory_rules(), or a caller-qualified register
#'   with the same columns. Caller records must retain source hash and dates.
#' @return Structured five-stage assessment. Unknown context returns
#'   REGULATORY_ASSESSMENT_NOT_DETERMINED; criteria results are not approval.
#' @export
assess_regulatory <- function(statistics, guideline = NA_character_, endpoint = NA_character_,
                              rule_id = NULL, jurisdiction = NULL, formulation = NULL,
                              eligibility_confirmed = NA, reference_replicated = NA,
                              reliable_variance = NA, cv_wr = NA_real_, confidence_level = NA_real_,
                              assessment_date = Sys.Date(), rules = regulatory_rules()) {
  out <- list(classification = "REGULATORY_ASSESSMENT_NOT_DETERMINED", guideline = guideline,
    endpoint = endpoint, statistics = statistics, rule = NULL,
    eligibility = list(determined = FALSE, eligible = NA), limits = NULL,
    stages = list(statistics = "RECEIVED", rule_selection = "NOT_SELECTED", eligibility = "NOT_DETERMINED",
                  limits = "NOT_DETERMINED", classification = "NOT_DETERMINED"),
    reason = "Select a qualified versioned rule and establish study-specific eligibility")
  abstain <- function(reason) {out$reason <- reason;out}
  if (is.null(rule_id)) return(out)
  if (length(rule_id)!=1 || is.na(rule_id) || !nzchar(rule_id)) return(abstain("A single rule identifier is required"))
  required <- names(regulatory_rules())
  if (!is.data.frame(rules) || !all(required %in% names(rules)) || anyDuplicated(rules$rule_id))
    return(abstain("Invalid or ambiguous rule register"))
  rule <- rules[rules$rule_id == rule_id & !is.na(rules$rule_id), , drop = FALSE]
  if (nrow(rule) != 1) return(abstain("Rule identifier is not uniquely registered"))
  out$rule <- as.list(rule[1, ]); out$guideline <- paste(rule$guideline, rule$version)
  out$stages$rule_selection <- "SELECTED"
  verified <- identical(rule$verification_status, "VERIFIED") && identical(rule$method_status, "QUALIFIED")
  safe_date <- function(x) tryCatch(as.Date(x), error = function(e) as.Date(rep(NA_character_, length(x))))
  dates <- safe_date(c(rule$verified_on, rule$effective_from, rule$effective_until))
  today <- safe_date(assessment_date)
  if (!verified || is.na(rule$version) || !nzchar(rule$version) || is.na(rule$source_sha256) || !grepl("^[a-fA-F0-9]{64}$", rule$source_sha256) ||
      is.na(rule$source_url) || !grepl("^https://", rule$source_url) ||
      is.na(dates[1]) || is.na(dates[2]) || length(today)!=1 || is.na(today) ||
      dates[1] > today || dates[2] > today || (!is.na(dates[3]) && today > dates[3]))
    return(abstain("Official source, effective window or analytical method has not been qualified for this date"))
  context_ok <- length(endpoint)==1 && !is.na(endpoint) &&
    endpoint %in% strsplit(rule$endpoints, "|", fixed = TRUE)[[1]] &&
    identical(jurisdiction, rule$jurisdiction) && identical(formulation, rule$formulation)
  if (!isTRUE(context_ok) || !isTRUE(eligibility_confirmed))
    return(abstain("Endpoint/formulation/jurisdiction eligibility is missing, incompatible or not confirmed"))
  if (length(confidence_level)!=1 || !is.finite(confidence_level) || abs(confidence_level-.90)>1e-12)
    return(abstain("A declared 90 percent confidence interval is required"))
  if (rule$method == "legacy_abel" && (!isTRUE(reference_replicated) || !isTRUE(reliable_variance)))
    return(abstain("ABEL requires confirmed reference replication and a reliable, justified variance estimate"))
  if (!rule$method %in% c("conventional_abe", "legacy_abel"))
    return(abstain("The selected numerical method is not implemented"))
  out$eligibility <- list(determined = TRUE, eligible = TRUE, analyst_attested = TRUE)
  out$stages$eligibility <- "CONFIRMED_BY_CALLER"
  limits <- tryCatch(if (rule$method == "legacy_abel") abel_limits(cv_wr) else c(lower=.8,upper=1.25),
                     error = function(e) NULL)
  if (is.null(limits)) return(abstain("A valid reference variance is required for the selected limits"))
  out$limits <- limits;out$stages$limits <- "CALCULATED"
  valid <- is.data.frame(statistics) && nrow(statistics)==1 && all(c("gmr","lower","upper") %in% names(statistics))
  if (!valid) return(abstain("A single identifiable statistical comparison is required"))
  decision <- tryCatch({
    s<-statistics
    if (length(s$gmr)!=1 || !is.finite(s$gmr) || s$gmr<s$lower || s$gmr>s$upper) stop("Invalid GMR")
    if (rule$method == "legacy_abel") numeric_abel(s$lower,s$upper,s$gmr,cv_wr) else numeric_abe(s$lower,s$upper,limits)
  }, error = function(e) NA)
  if (is.na(decision)) return(abstain("Invalid or nonestimable statistical output"))
  out$stages$statistics <- "NUMERIC_COMPARISON_CHECKED"
  out$classification <- if (decision) "REGULATORY_CRITERIA_MET" else "REGULATORY_CRITERIA_NOT_MET"
  out$stages$classification <- "COMPUTED_AGAINST_CALLER_QUALIFIED_RULE"
  out$reason <- "Numerical criteria evaluated under caller-attested qualification; this is not regulatory approval"
  out
}
