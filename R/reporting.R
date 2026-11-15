#' Write a traceable analysis bundle
#' @param result OpenBE analysis result.
#' @param directory Output directory.
#' @return Output directory, invisibly.
#' @export
write_analysis <- function(result, directory) {
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(result$summary,file.path(directory,"summary.csv"),row.names = FALSE)
  saveRDS(result,file.path(directory,"analysis.rds"))
  writeLines(utils::capture.output(utils::sessionInfo()),file.path(directory,"sessionInfo.txt"))
  writeLines(utils::capture.output(str(result$regulatory)),file.path(directory,"regulatory.txt"))
  if (!is.null(result$anova)) utils::write.csv(as.data.frame(unclass(result$anova)),file.path(directory,"anova.csv"))
  if (!is.null(result$geometric_lsmeans)) utils::write.csv(as.data.frame(result$geometric_lsmeans),
    file.path(directory,"geometric-lsmeans.csv"))
  invisible(directory)
}
