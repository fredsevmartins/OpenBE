# Initialize engine namespaces when OpenBE loads. Some engines install required
# defaults in .onLoad; these must exist before an analysis snapshots options.
#' @importFrom BE test2x2
#' @importFrom replicateBE method.A method.B
#' @importFrom nlme lme
#' @importFrom lme4 getME isSingular
#' @importFrom lmerTest lmer
#' @importFrom emmeans emmeans contrast
#' @importFrom PKNCA pk.nca
#' @importFrom ggplot2 ggplot
#' @importFrom digest digest
#' @importFrom jsonlite write_json
NULL
