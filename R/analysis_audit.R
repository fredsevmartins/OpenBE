# Isolate third-party engines from the caller's contrast settings and restore
# every option, including options created or removed by an engine on error.
analysis_session <- function() {
  old <- options()
  options(contrasts = c("contr.treatment", "contr.poly"))
  function() {
    added <- setdiff(names(options()), names(old))
    if (length(added)) options(stats::setNames(rep(list(NULL), length(added)), added))
    options(old)
    invisible(NULL)
  }
}

record_fit <- function(expr) {
  messages <- character()
  value <- withCallingHandlers(expr, warning = function(w) {
    messages <<- c(messages, conditionMessage(w))
  })
  list(value = value, warnings = unique(messages))
}

fit_diagnostics <- function(model, warnings = character()) {
  mixed <- inherits(model, "lme") || inherits(model, "merMod")
  x <- if (inherits(model, "lme")) {
    stats::model.matrix(stats::formula(model), nlme::getData(model))
  } else if (inherits(model, "merMod")) lme4::getME(model, "X") else stats::model.matrix(model)
  boundary <- if (inherits(model, "merMod")) lme4::isSingular(model) else NA
  covariance <- if (inherits(model, "lme") && is.character(model$apVar)) model$apVar else NA_character_
  optimizer_messages <- if (inherits(model, "merMod")) model@optinfo$conv$lme4$messages else NULL
  variance_components <- if (inherits(model, "lme")) {
    v <- nlme::VarCorr(model)
    data.frame(component = rownames(v), variance = as.numeric(v[, "Variance"]),
               standard_deviation = as.numeric(v[, "StdDev"]))
  } else if (inherits(model, "merMod")) as.data.frame(lme4::VarCorr(model)) else NULL
  list(model_class = class(model)[1], variance_components = variance_components, formula = paste(deparse(stats::formula(model)), collapse = " "),
       fit_method = if (mixed) "REML" else "OLS", fixed_rank = qr(x)$rank,
       fixed_columns = ncol(x), residual_sd = unname(stats::sigma(model)),
       optimizer_status = if (mixed) "RETURNED_MODEL_REVIEW_WARNINGS" else "NOT_APPLICABLE",
       singular_random_effect = boundary, covariance_warning = covariance,
       optimizer_messages = optimizer_messages,
       optimizer_codes = if (inherits(model, "merMod")) model@optinfo$conv$opt else NULL,
       warnings = unique(warnings))
}

analysis_audit <- function(data, model, engine, method, df_method, warnings = character(),
                           covariance = "Common residual log variance") {
  packages <- unique(c("OpenBE", engine))
  versions <- vapply(packages, function(p) as.character(utils::packageVersion(p)), character(1))
  list(schema_version = "1.0", created_utc = format(Sys.time(), tz = "UTC", usetz = TRUE),
       population = attr(data, "OpenBE_population"), engine_versions = as.list(versions),
       method = method, df_method = if (is.null(names(df_method))) df_method else as.list(df_method), covariance = covariance,
       model = fit_diagnostics(model, warnings),
       scientific_status = "Targeted numerical tests do not establish independent clinical qualification")
}
