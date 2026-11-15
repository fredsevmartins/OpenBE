# Verified package capability matrix

Audit date: 2026-11-15. R 4.5.0, Debian 13, x86_64. Exact installed versions and
licenses are in [package-versions.csv](package-versions.csv). Source commit pins
are in [source-pins.json](../../inst/extdata/source-pins.json). Full function
signatures, available datasets and PowerTOST design names were inspected
programmatically; see [installed-engine-audit.txt](installed-engine-audit.txt).

Direct HTTPS CRAN access returned CONNECT HTTP 403 under the current network
policy. The audit therefore inspected the CRAN-maintained `github.com/cran/*`
source mirrors and the help installed from those pinned sources. It does not
claim a successful live query to cran.r-project.org. Source dates and versions
are those actually inspected, not assumptions based on older tutorials.

| Engine | Verified interface | Analysis capabilities used | Limits and classification |
|---|---|---|---|
| BE 0.3.0 | `test2x2(bedata, Var)`; `be2x2(Data, Columns, rtfName)` | Complete TR/RT 2-period endpoints; type III ANOVA, subject(sequence), geometric LS means, T/R CI, CV | Engine delegates to sasLM 1.0.1; no general replicate analysis is inferred from its sample-size functions; no incomplete-subject support in OpenBE wrapper |
| replicateBE 1.1.3 | `method.A(..., print=FALSE, details=TRUE)` | Fixed sequence, subject(sequence), period, treatment; separate within-R/T subset variance models | Tested designs 02–11 below; engine's historical EMA interpretation is retained only as raw output |
| replicateBE 1.1.3 | `method.B(..., option=2)` | REML random subject intercept, fixed sequence/period/treatment; containment DF | Common residual variance; not a heteroscedastic FDA RSABE model; actual source uses nlme for option 2 |
| replicateBE 1.1.3 | `method.B(..., option=1 or 3)` | lmerTest Satterthwaite or Kenward–Roger DF | Source comments/help contain older option/backend descriptions; source inspection resolves the mapping |
| PowerTOST 1.5-7 | `sampleN.TOST`, `power.TOST`, `sampleN.scABEL`, `known.designs` | Conventional and reference-scaled planning | Planning design support is not an endpoint-analysis engine or regulatory eligibility check; scaled power is Monte Carlo |
| PKNCA 0.12.1 | `PKNCAconc`, `PKNCAdose`, `PKNCAdata`, `pk.nca` | Cmax, Tmax, AUClast, AUCinf.obs, lambda.z, half.life, aucpext.obs; user-defined dosing intervals | Wrapper requires units, positive dose and explicit intervals; no clinical qualification of terminal-phase selections; multiple-dose intervals require a justified steady-state protocol |
| stats 4.5.0 | `lm`, `pt`, `qt` | Equal log-variance independent parallel groups | OpenBE EXPERIMENTAL, not BE package parallel support |
| nlme 3.1-168 + emmeans | `lme`, `emmeans`, `contrast` | Complete 3/4-treatment Williams structures, random subject intercept, test-vs-R contrasts | OpenBE EXPERIMENTAL; common variance, no differential carryover; unadjusted 90% CIs with separate Holm-adjusted TOST p-values |
| lme4/lmerTest | installed, used by replicateBE options 1/3 | Mixed-model alternatives | No unimplemented heterogeneous replicate covariance claim |
| ggplot2 | `ggplot`, `ggsave` | PNG 300 dpi and PDF figures | Profiles only for actual concentration data |
| dplyr/tidyr/readr/readxl | installed; readxl used by replicateBE | Data handling / Excel backend | CSV uses base R for a smaller public interface |
| quarto/knitr/rmarkdown | installed R interfaces + Quarto CLI 1.8.27 | Executable tutorials and website rendering | CLI is separate from quarto R package |
| testthat/renv/roxygen2/pkgdown | installed | Tests, lockfile, API help; pkgdown investigated | Website uses Quarto; pkgdown is an available alternative, not a second deployed site |

## Replicate designs actually documented by the engine

| OpenBE design | Sequences | Source reference data |
|---|---|---|
| 02 | TRTR / RTRT | rds01 |
| 03 | TRRT / RTTR | rds05 |
| 04 | TTRR / RRTT | rds28 |
| 05 | TRTR / RTRT / TRRT / RTTR | rds23 |
| 06 | TRRT / RTTR / TTRR / RRTT | rds24 |
| 07 | TRT / RTR | rds03 |
| 08 | TRR / RTT | rds10 |
| 09 | TR / RT / TT / RR | rds27 |
| 10 | TRR / RTR / RRT | rds02 |
| 11 | TRR / RTR | rds22 |

Evidence: installed `?replicateBE::method.A`, `?replicateBE::method.B` and
`?replicateBE::refdata`, corroborated against R/method.A.R, R/method.B.R,
R/CV.calc.R, R/get.data.R and R/info.design.R in the source pin. Execution is
recorded separately in the validation report; documentation support alone
is not numerical validation.

## Licensing

OpenBE is AGPL-3 because its scientific integration includes PKNCA (AGPL-3).
BE/sasLM are GPL-3; replicateBE is GPL >=3; PowerTOST is GPL >=2 and allows a
GPLv3-compatible choice. R and the modeling/data/documentation dependencies
retain their installed licenses. No third-party engine source is vendored.
Redistributors must retain notices and satisfy the applicable source obligations,
including AGPL network-use obligations when modifying and offering the program
as a service. This is a technical license inventory, not legal advice. Source
package licenses and citations remain authoritative.
