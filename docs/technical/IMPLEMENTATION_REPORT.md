# Initial implementation report

Repository: https://github.com/fredsevmartins/OpenBE

Development branch: `codex/initial-scientific-implementation`; target: `main`.
The initially empty remote required a small project-governance baseline for main;
implementation commits are kept on the dedicated branch. No automatic merge.

## Delivered and verified

- Installable R package, documented public API, source-pinned engine audit,
  dataset provenance/licenses, lockfile and separate regulatory assessment.
- Designs 01–14 executed; both AUClast and Cmax for design 01. Methods A/B for
  02–11; custom parallel/Williams remain experimental.
- Observed Theoph NCA and PowerTOST planning/sensitivity examples.
- 13 test blocks, 158 passing expectations; zero failures/errors/skips.
- 84 expected/observed numerical comparisons passed explicit tolerances.
- 95 PNG figures at 300 dpi and 95 vector PDFs; 16 English executable tutorials
  rendered. Initial 28-page Quarto site had zero missing local links/images.
- R CMD check --no-manual: Status OK. Non-root bootstrap tested in the normal
  prefix, repeat execution and a separate initially empty installation prefix.

## Study-design completion evidence

| Design | Implemented | Executed | Independently Validated | Tutorial | Figures (PNG + PDF) |
|---|---|---|---|---|---|
| 01 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_01_2x2_crossover.qmd) | 16 |
| 02 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_02_full_replicate_TRTR_RTRT.qmd) | 14 |
| 03 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_03_full_replicate_TRRT_RTTR.qmd) | 14 |
| 04 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_04_full_replicate_TTRR_RRTT.qmd) | 14 |
| 05 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_05_four_sequence_replicate.qmd) | 14 |
| 06 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_06_alternative_four_sequence_replicate.qmd) | 14 |
| 07 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_07_three_period_full_replicate.qmd) | 14 |
| 08 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_08_alternative_three_period_replicate.qmd) | 14 |
| 09 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_09_balaam.qmd) | 14 |
| 10 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_10_partial_replicate.qmd) | 14 |
| 11 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_11_extra_reference.qmd) | 14 |
| 12 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_12_parallel.qmd) | 8 |
| 13 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_13_williams_three_treatments.qmd) | 8 |
| 14 | Yes | Yes | No; targeted checks only | [English tutorial](../tutorials/design_14_williams_four_treatments.qmd) | 8 |

Designs 01–11: TESTED_NOT_INDEPENDENTLY_VALIDATED. Designs 12–14: EXPERIMENTAL.
No complete method is labeled VALIDATED. Mathematical cross-checks on selected
inputs are distinguished from full external software qualification.

## Engines and reference data

R 4.5.0; BE 0.3.0 / sasLM 1.0.1; replicateBE 1.1.3; PowerTOST 1.5-7;
PKNCA 0.12.1; nlme 3.1-168; lmerTest 3.1-3; emmeans 1.10.7;
Quarto CLI 1.8.27. Full versions/licenses: [package inventory](package-versions.csv).

Data: BE::NCAResult4BE; replicateBE rds01, rds05, rds28, rds23, rds24, rds03,
rds10, rds27, rds02, rds22; OpenBE synthetic designs 12–14 (seeds 12012,
13013, 14014); observed datasets::Theoph. Original attribution, source terms
and simulation assumptions are in [provenance](../../inst/extdata/PROVENANCE.md).

Numerical differences/tolerances and evidence strength are recorded per metric
in [numerical comparisons](../validation/numerical-comparisons.csv) and
[validation report](../validation/VALIDATION_REPORT.md).

## Scientific limitations

No current jurisdiction-specific rule has been qualified because official
regulatory sites returned CONNECT HTTP 403. OpenBE returns
REGULATORY_ASSESSMENT_NOT_DETERMINED. Legacy EMA ABEL calculations do not
qualify AUC scaling, FDA RSABE or NTI use. Method B assumes a common residual
variance. Custom methods, incomplete/covariance-sensitive cases, terminal NCA
selection and study-specific BLQ policy need broader independent qualification.
Historical source-package simulations have no invented generation parameters.
Balaam/extra-reference support is not a recommendation for new studies.

## Reproduction

From the repository root, after R/dependencies are available:

```sh
Rscript scripts/install_dependencies.R
R CMD INSTALL .
Rscript examples/design_01_2x2_crossover/analysis.R
Rscript scripts/run_all_examples.R
Rscript scripts/run_validation.R
R CMD build .
R CMD check --no-manual OpenBE_0.1.0.tar.gz
Rscript scripts/build_documentation.R
```

For this non-root cloud image use `bash scripts/setup_cloud.sh`, then put
`/workspace/toolchain/bin` on PATH; scientific scripts use relative paths.
A complete fresh CRAN-backed renv restore was not tested under the restricted
network. The separate-prefix GitHub-source/native bootstrap was tested.

## Remote publication status

Git publication and PR creation are recorded separately in PUBLISHING_STATUS.md.
The GitHub API currently returns CONNECT HTTP 403; this prevents verifying
API authentication or creating a PR through gh. A Pages-compatible build and
Actions deployment workflow exist, but remote CI execution and Pages deployment
have not been verified. No deployed URL is claimed.
