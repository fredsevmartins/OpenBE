# OpenBE 0.1.1: robustness and scientific audit

## Session-independent model specification

All four analysis entry points normalize treatment coding within a protected
scope and restore the caller's complete R options on success and error. Model
formulas use explicit reference coding where coefficients are extracted by name.
Regression tests compare results under treatment, sum and Helmert contrasts.
The replicateBE digits/contrast side effect is contained by the adapter.

A positive residual DF is insufficient evidence of estimability. The primary
fixed-subject design must have full column rank and finite estimable effects.
A deliberately confounded example with positive DF is now rejected before the
engine call. Structural allocation errors cannot be hidden by omitting missing
endpoints. Separate variance-subset models can have structural nuisance aliases;
they retain the engine's residual-DF variance calculation rather than imposing
an inappropriate full-rank requirement on every subset.

## Independent numerical evidence

A reference implementation in `tests/testthat/helper-independent-reml.R` uses
Woodbury inversion and a profile restricted-likelihood objective for the
random-intercept covariance `V = sigma_e^2 I + sigma_b^2 ZZ'`. It does not call
OpenBE analyses, replicateBE, nlme or lme4. It cross-checks Method B GMR, interval
and containment DF on the ten example designs. An observed-information finite-
difference delta method independently cross-checks Satterthwaite DF on three
source datasets, including incomplete/unbalanced data.

For the complete balanced orthogonal case, Kenward-Roger reduces to the exact
within-subject residual variance and DF; that limiting case is checked. General
incomplete/unbalanced Kenward-Roger still needs a qualified external reference.
These are targeted checks with explicit tolerances, not blanket validation.
The original rounded published/package-reference example remains labeled
shared-engine corroboration in the numerical comparison register.

References:

- Harville DA. Maximum likelihood approaches to variance component estimation
  and to related problems. JASA. 1977;72:320–338. DOI:10.1080/01621459.1977.10480998.
- Satterthwaite FE. An approximation of the distribution of estimates of variance
  components. Biometrics Bulletin. 1946;2:110–114. DOI:10.2307/3002019.
- Kenward MG, Roger JH. Small sample inference for fixed effects from restricted
  maximum likelihood. Biometrics. 1997;53:983–997. DOI:10.2307/2533558.

## Population and model reports

Every endpoint analysis includes `audit`: source-data SHA-256, retained source
row numbers, explicit missing-PK exclusions, absent planned subject-period
records, subject/observation counts, sequence counts, engine versions, formula,
DF method, covariance assumptions, rank and captured warnings. Replicate analyses
include a diagnostic Method B refit with the same specification; primary
estimates remain the package engine output. A returned model is not proof of
unconditional convergence; inspect optimizer messages, singularity and variance-
uncertainty warnings.

`write_analysis()` exports `report.md`, `audit.json`, `excluded-observations.csv`
and `absent-records.csv` alongside existing results. JSON represents nonfinite
values as strings to distinguish unbounded intervals from missing values.
Numeric audit fields retain full precision. Endpoint input fingerprints hash
the original five-column R data object using serialization version 2; NCA
fingerprints hash the input concentration/dose objects. File-byte SHA-256
checksums are recorded separately in the dataset register.

## NCA policies, units and terminal points

`analyze_nca()` defaults to rejecting missing concentrations. Explicit omission
is recorded by source row. `blq_policy` supports recorded engine handling,
rejection, omission, zero retention and LLOQ/2; the latter requires a supplied
positive assay limit. These are analyst-selected policies, not universally
recommended clinical procedures. No LLOQ is inferred from measured data.

Recognized concentration units are mg/L, ug/mL, ng/mL, ug/L, ng/L and mg/mL;
time units are h, min and s; dose units are g, mg, ug and ng, optionally per kg.
Conversions are explicit through `target_units`; concentration, dose, times and
interval limits are converted together. Other time-valued options must use the
target units. Converting mg/kg to mg is rejected without body weight. No opaque
unit label is silently accepted as a validated dimensional conversion.

Terminal membership is obtained from `PKNCA::get_halflife_points()` and is stored
per interval, including overlapping intervals. Engine first/last time, point
count, R-squared, adjusted R-squared and span ratio are requested when terminal
parameters are requested. Zero concentrations within a reported terminal window
are identified separately from positive regression points. Parameter exclusion
reasons remain in the PKNCA result table. `write_nca()` exports audit JSON,
observation actions, terminal-point CSV, numerical results and the RDS bundle.

## Regulatory qualification gates

`regulatory_rules()` exposes versioned metadata for ICH conventional ABE,
historical EMA ABEL and FDA RSABE. All shipped rules are blocked/unqualified:
source access, current scope, effective dates and analytical qualification have
not been established. `scripts/audit_regulatory_sources.R` records access,
retrieved-source hashes when available and review status. Retrieval alone never
qualifies a rule. Current access evidence is in `docs/regulatory/source-access.csv`.

`assess_regulatory()` separates statistical output, source/rule selection,
eligibility, numerical limits and classification. A custom register is an
explicit caller attestation, with required source hash and verification/effective
dates. Tests use unmistakably synthetic policy metadata; they are not official
policy validation. Unknown, expired, mismatched or unqualified rules abstain.
Historical ABEL additionally requires Cmax eligibility, explicit reference
replication and reliable-variance confirmation; no AUC widening is inferred.
Criteria being met is not regulatory approval.

## Installation and CI

R CMD check is configured on Linux, Windows and macOS with R 4.5.0, plus Linux
R release. `scripts/check_package.R` derives the tarball version from DESCRIPTION
and preserves command exit codes. Dataset hashes use digest rather than a
Unix-only executable. A separate CI job restores an empty library with cache
reuse disabled and checks exact versions before installing and smoke-testing
OpenBE. R-bundled libraries remain part of the declared R toolchain.

The clean-restore script stops before installation if CRAN access is blocked.
A configured CI matrix is not evidence of completed remote tests. In this
runtime, CRAN and official regulatory source retrieval remain blocked; no
successful fresh CRAN restore or new operating-system run is claimed without
its actual result. The already-tested local native/source bootstrap remains
available for this restricted Debian cloud image.

## Executed verification

The local suite passed 267 expectations across 29 test blocks, with no failures,
errors or skipped tests. All 136 recorded numerical comparisons passed. The
installed-package R CMD check completed with Status OK, including Satterthwaite
and Kenward-Roger paths in a fresh R process. The ten containment-reference DF
checks use absolute tolerance 1e-8; Satterthwaite DF uses absolute tolerance
0.001 for the finite-difference reference. The comparison CSV records every
actual difference and tolerance.

A packaging check revealed a namespace-initialization issue missed by the
interactive development loader: lme4 installs required defaults at load time.
Engine namespaces now initialize with OpenBE before analysis option snapshots,
so restoring caller options preserves those initialized defaults. Installed-
package regression checks exercise all three DF paths and option restoration.
