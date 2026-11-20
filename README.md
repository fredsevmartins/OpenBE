# OpenBE — Open-Source Bioequivalence Analysis


OpenBE is an R research toolkit for traceable bioequivalence analysis. It uses
established statistical engines, provides executable design examples, and
separates statistical calculations from regulatory eligibility and conclusions.

This release contains **14 executed design workflows**, observed-data NCA,
sample-size/power examples, **267 passing test expectations**, **136 numerical
comparisons**, **95 figures in PNG (300 dpi) plus 95 vector PDFs**, and **16
executable English tutorials**. No Shiny interface is included.

## Version 0.1.1 improvements

Session-safe contrasts, early estimability checks, independent REML/DF checks,
population/model audit reports, explicit NCA policies and unit conversions,
terminal-point exports, versioned regulatory qualification gates and a
cross-platform CI matrix are described in the
[0.1.1 technical report](docs/technical/HARDENING_0.1.1.md).
No built-in regulatory rule is qualified; custom registers are caller attestations.

## Features

- Conventional 2×2: BE ANOVA with subject nested within sequence, geometric LS
  means, GMR, 90% CI, TOST and within-subject CV for AUClast and Cmax.
- Ten replicate designs: replicateBE Methods A and B, reference/test variability
  where estimable, ABE numerical containment and historical ABEL calculations.
- Experimental equal-variance parallel and three/four-treatment Williams models.
- PKNCA: observed Theoph concentration profiles, Cmax/Tmax, AUC, terminal
  parameters, extrapolation and an explicitly synthetic repeat-dose example.
- PowerTOST: conventional/replicate planning, power and CV/GMR sensitivity.
- Source-pinned dependencies, reproducible scripts, numerical evidence,
  programmatic figures, Quarto website and GitHub Actions workflows.

## Supported designs

“Tested” below means TESTED_NOT_INDEPENDENTLY_VALIDATED. Targeted independent
mathematical checks have passed; no whole method is classified VALIDATED.
Custom OpenBE implementations remain EXPERIMENTAL.

| Design | Sequences | Periods | Engine | Analytical status | Validation | Tutorial |
|---|---|---|---|---|---|---|
| 01 | TR / RT | 2 | BE | Research workflow | Tested | [Tutorial](docs/tutorials/design_01_2x2_crossover.qmd) |
| 02 | TRTR / RTRT | 4 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_02_full_replicate_TRTR_RTRT.qmd) |
| 03 | TRRT / RTTR | 4 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_03_full_replicate_TRRT_RTTR.qmd) |
| 04 | TTRR / RRTT | 4 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_04_full_replicate_TTRR_RRTT.qmd) |
| 05 | TRTR / RTRT / TRRT / RTTR | 4 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_05_four_sequence_replicate.qmd) |
| 06 | TRRT / RTTR / TTRR / RRTT | 4 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_06_alternative_four_sequence_replicate.qmd) |
| 07 | TRT / RTR | 3 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_07_three_period_full_replicate.qmd) |
| 08 | TRR / RTT | 3 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_08_alternative_three_period_replicate.qmd) |
| 09 | TR / RT / TT / RR | 2 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_09_balaam.qmd) |
| 10 | TRR / RTR / RRT | 3 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_10_partial_replicate.qmd) |
| 11 | TRR / RTR | 3 | replicateBE | Research workflow | Tested | [Tutorial](docs/tutorials/design_11_extra_reference.qmd) |
| 12 | T / R | 1 | stats::lm (OpenBE) | Research workflow | EXPERIMENTAL | [Tutorial](docs/tutorials/design_12_parallel.qmd) |
| 13 | ABR / BRA / RAB / RBA / ARB / BAR | 3 | nlme + emmeans (OpenBE) | Research workflow | EXPERIMENTAL | [Tutorial](docs/tutorials/design_13_williams_three_treatments.qmd) |
| 14 | ABCR / BRAC / RCBA / CARB | 4 | nlme + emmeans (OpenBE) | Research workflow | EXPERIMENTAL | [Tutorial](docs/tutorials/design_14_williams_four_treatments.qmd) |

Balaam and extra-reference designs are provided for reproducibility and teaching,
with explicit warnings against recommending them for new regulatory studies.
Williams designs involve distinct treatments and are not replicate BE designs.

## Installation

Requires R >=4.1; tested with **R 4.5.0**. The complete implementation is
available on the default `main` branch:

```r
install.packages("remotes")
remotes::install_github("fredsevmartins/OpenBE")
```

For development with the exact package lock:

```sh
git clone https://github.com/fredsevmartins/OpenBE.git
cd OpenBE
git checkout main
Rscript scripts/install_dependencies.R
R CMD INSTALL .
```

Install Quarto CLI separately (tested: 1.8.27). On a restricted non-root Debian
13 cloud machine, `bash scripts/setup_cloud.sh` provides the tested bootstrap.
It verifies signed Debian package metadata and Quarto's published SHA-256,
and uses immutable CRAN GitHub source pins when direct CRAN access is blocked.
The native package inventory and exact dependency versions are recorded in
[technical documentation](docs/technical/PACKAGE_CAPABILITIES.md).

## Quick start

```r
library(OpenBE)
d <- example_dataset(1, "AUClast")
fit <- analyze_2x2(d)
fit$summary
fit$geometric_lsmeans
fit$cv_within
fit$regulatory$classification
# "REGULATORY_ASSESSMENT_NOT_DETERMINED"
```

## Scientific examples and reproduction

Every design tutorial above links its independent script, source, model,
outputs, figures, interpretation and limitations. Additional tutorials:
[pharmacokinetics](docs/tutorials/pharmacokinetic_analysis.qmd) and
[sample size and power](docs/tutorials/sample_size_and_power.qmd).

Run from the repository root after installation:

```sh
Rscript examples/design_01_2x2_crossover/analysis.R
Rscript scripts/run_all_examples.R
Rscript scripts/generate_figures.R
Rscript scripts/run_validation.R
Rscript scripts/run_nca.R
Rscript scripts/run_planning.R
R CMD build .
R CMD check --no-manual OpenBE_0.1.1.tar.gz
Rscript scripts/build_documentation.R
```

`run_all_examples.R` already generates figures and includes NCA/planning;
`generate_figures.R` regenerates the same model-linked figures. Each design's
outputs contain `summary.csv`, analysis RDS, session details, regulatory status,
PNG and PDF figures; `write_analysis()` creates report bundles. Rendering Quarto
generates human-readable reports and a GitHub Pages-compatible `_site/`.
Generated outputs are overwritten deterministically; originals stay in
`inst/extdata/`. No undocumented local data or absolute project paths are used
by analyses or tests.

## Statistical methodology

Natural-log endpoint models produce exponentiated treatment contrasts. BE
supplies the conventional primary ANOVA and estimates; replicateBE supplies
fixed-effect Method A and REML random-intercept Method B. The latter assumes
**a common residual variance**, not a treatment-specific FDA RSABE covariance
model. CVwT is missing where replication cannot identify it. Custom parallel
models assume equal group log variances; Williams models use nlme and emmeans,
unadjusted 90% CIs and separate Holm-adjusted TOST p-values.

See [models and assumptions](docs/statistical-methods.md) and the
[verified capability matrix](docs/technical/PACKAGE_CAPABILITIES.md).

## Regulatory considerations

Numerical ABE/legacy ABEL calculations do not establish regulatory eligibility.
Official-source retrieval was blocked by HTTP 403 in this environment, so
current ICH M13A/EMA/FDA applicability is **not qualified**. All shipped rules are unqualified; default assessments return
`REGULATORY_ASSESSMENT_NOT_DETERMINED`. The versioned registry and explicit
qualification gates are documented in the technical report. No AUC
scaling eligibility, FDA RSABE implementation, NTI procedure, regulatory approval
or endorsement is claimed. See the [regulatory framework](docs/regulatory-framework.md).

## Validation

Local `R CMD check --no-manual` passed with **Status: OK**. The test suite passed
267 expectations across 29 test blocks, with no failures, errors or skips;
136 recorded expected/observed comparisons passed explicit absolute tolerances.
These include independent stratified-difference and normal-equation checks,
rounded EMA reference-example corroboration, analytical exponential NCA,
input/boundary tests, DF options, Williams balance and reproducible planning.

Read the [validation report](docs/validation/VALIDATION_REPORT.md),
[numerical comparisons](docs/validation/numerical-comparisons.csv) and
[per-design evidence](docs/validation/design-status.csv) for the exact scope.
Shared-engine corroboration is distinguished from independent validation.

## Reproducibility and documentation

`renv.lock` records R/package versions; immutable source pins, input SHA-256,
synthetic model assumptions/seeds and session files support traceability.
Observed, edited and synthetic data are distinguished in
[dataset provenance](inst/extdata/PROVENANCE.md). Historical package simulations
have no invented seeds; their pinned values are reused.

All 14 design tutorials plus NCA and planning rendered locally without manual
intervention. The generated site's local images/links were checked. GitHub
Actions workflows are configured for package checks, numerical validation and
documentation; local execution does not prove remote CI success. Pages deployment
is configured for main but **has not been verified or claimed**. No live site
URL is asserted. API help is generated in `man/` and
[API reference](docs/api-reference.md).

## Citation

Use `citation("OpenBE")` and cite the engines and original datasets used in
an analysis. Machine-readable project citation: [CITATION.cff](CITATION.cff).
See [references](docs/references.md).

## License

OpenBE is **AGPL-3**, compatible with its PKNCA integration. Engine packages and
datasets retain their source licenses and attribution requirements. See
[full license](LICENSE.md), [license inventory](docs/technical/PACKAGE_CAPABILITIES.md)
and [dataset terms](inst/extdata/PROVENANCE.md). No clinical-data relicensing
claim is made.

## Disclaimer

Scientific research software. Regulatory use requires appropriate qualification,
validation and review of the applicable current guidance. OpenBE is not approved,
certified or endorsed by a regulatory agency.
