#' Conventional and replicate study planning
#'
#' Wraps PowerTOST sampleN.TOST or sampleN.scABEL; design names must be supported
#' by the selected engine. Planning support does not imply analysis support.
#' Reference-scaled planning uses historical engine rules, not regulatory approval.
#' @param cv Assumed within-subject CV (fraction).
#' @param ratio Expected Test/Reference geometric mean ratio.
#' @param power Target power between zero and one.
#' @param design PowerTOST design name (for example 2x2 or 2x2x4).
#' @param scaled Use reference-scaled simulation planning.
#' @param seed Fixed seed used for simulation planning.
#' @param nsims Number of simulations for scaled planning.
#' @return PowerTOST sample-size results.
#' @export
plan_be <- function(cv = 0.2, ratio = 0.95, power = 0.8, design = "2x2",
                    scaled = FALSE, seed = 20261115, nsims = 10000) {
  if (length(cv) != 1 || !is.finite(cv) || cv <= 0 ||
      length(ratio) != 1 || !is.finite(ratio) || ratio <= 0 ||
      length(power) != 1 || !is.finite(power) || power <= 0 || power >= 1)
    stop("Invalid planning inputs")
  if (scaled) {
    old <- if (exists(".Random.seed", envir = .GlobalEnv)) get(".Random.seed", envir = .GlobalEnv) else NULL
    on.exit(if (is.null(old)) {
      if (exists(".Random.seed", envir = .GlobalEnv)) rm(".Random.seed", envir = .GlobalEnv)
    } else assign(".Random.seed", old, envir = .GlobalEnv), add = TRUE)
    set.seed(seed)
    PowerTOST::sampleN.scABEL(CV = cv, theta0 = ratio, targetpower = power,
      design = design, regulator = "EMA", nsims = nsims, setseed = FALSE,
      print = FALSE, details = FALSE)
  } else {
    PowerTOST::sampleN.TOST(CV = cv, theta0 = ratio, targetpower = power,
                           design = design, print = FALSE)
  }
}
