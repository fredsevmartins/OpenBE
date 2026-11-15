#' Write a traceable analysis bundle
#' @param result OpenBE analysis result.
#' @param directory Output directory.
#' @return Output directory, invisibly.
#' @export
write_analysis <- function(result, directory) {
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(result$summary,file.path(directory,"summary.csv"),row.names = FALSE)
  saveRDS(result,file.path(directory,"analysis.rds"))
  if (!is.null(result$audit)) {
    jsonlite::write_json(result$audit, file.path(directory, "audit.json"),
      pretty = TRUE, auto_unbox = TRUE, na = "string", digits = NA)
    population <- result$audit$population
    utils::write.csv(population$exclusions, file.path(directory, "excluded-observations.csv"), row.names = FALSE)
    utils::write.csv(population$absent_records, file.path(directory, "absent-records.csv"), row.names = FALSE)
    text <- c("# Analysis report", "", paste("Method:", result$audit$method),
      paste("Degrees of freedom:", paste(names(result$audit$df_method), result$audit$df_method, collapse = "; ")),
      paste("Model:", result$audit$model$formula), paste("Covariance:", result$audit$covariance),
      paste("Analyzed observations:", population$analyzed_rows, "of", population$input_rows),
      paste("Analyzed subjects:", population$analyzed_subjects),
      paste("Absent planned records:", nrow(population$absent_records)),
      paste("Input SHA-256:", population$input_sha256), "", "## Estimates", "", "```text",
      utils::capture.output(print(result$summary)), "```", "", "## Model diagnostics", "", "```text",
      utils::capture.output(str(result$audit)), "```", "", "## Regulatory assessment", "", "```text",
      utils::capture.output(str(result$regulatory)), "```", "", result$audit$scientific_status)
    writeLines(text, file.path(directory, "report.md"))
  }
  writeLines(utils::capture.output(utils::sessionInfo()),file.path(directory,"sessionInfo.txt"))
  writeLines(utils::capture.output(str(result$regulatory)),file.path(directory,"regulatory.txt"))
  if (!is.null(result$anova)) utils::write.csv(as.data.frame(unclass(result$anova)),file.path(directory,"anova.csv"))
  if (!is.null(result$geometric_lsmeans)) utils::write.csv(as.data.frame(result$geometric_lsmeans),
    file.path(directory,"geometric-lsmeans.csv"))
  invisible(directory)
}

#' Export a traceable PKNCA result bundle
#' @param result PKNCAresults returned by analyze_nca().
#' @param directory Output directory.
#' @return Output directory, invisibly.
#' @export
write_nca <- function(result, directory) {
  audit <- attr(result, "OpenBE_audit")
  if (is.null(audit)) stop("An OpenBE NCA audit is required")
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(as.data.frame(result), file.path(directory, "nca.csv"), row.names = FALSE)
  utils::write.csv(audit$observation_actions, file.path(directory, "observation-actions.csv"), row.names = FALSE)
  utils::write.csv(audit$terminal_points, file.path(directory, "terminal-points.csv"), row.names = FALSE)
  jsonlite::write_json(audit, file.path(directory, "audit.json"), pretty = TRUE, auto_unbox = TRUE, na = "string", digits = NA)
  saveRDS(result, file.path(directory, "nca.rds"))
  writeLines(utils::capture.output(utils::sessionInfo()), file.path(directory, "sessionInfo.txt"))
  invisible(directory)
}
