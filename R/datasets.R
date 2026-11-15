#' Load a packaged demonstration dataset
#' @param design Integer study design from 1 to 14.
#' @param endpoint For design 1, AUClast or Cmax.
#' @return Data frame. See inst/extdata/PROVENANCE.md before interpretation.
#' @export
example_dataset <- function(design = 1, endpoint = c("AUClast","Cmax")) {
  if (length(design) != 1 || !is.finite(design) || design != as.integer(design) ||
      design < 1 || design > 14) stop("design must be an integer from 1 to 14")
  suffix <- if (design == 1) paste0("_",match.arg(endpoint)) else ""
  path <- system.file("extdata",sprintf("design_%02d%s.csv",design,suffix),package="OpenBE")
  if (!nzchar(path)) stop("Packaged dataset not found")
  utils::read.csv(path,stringsAsFactors=FALSE)
}
