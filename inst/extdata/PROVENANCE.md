# Dataset provenance and redistribution

No endpoint-only dataset has been converted into measured concentration-time
profiles. `data-raw/prepare_datasets.R` reproduces every packaged CSV. Source
pins are in `source-pins.json`; checksums are generated during validation.

| Designs | Dataset and original source | Classification | Source terms |
|---|---|---|---|
| 01 | BE 0.3.0 `NCAResult4BE`, AUClast and Cmax; 33 complete subjects | Simulated by the source package using NonCompart; not observed clinical data | BE GPL-3 |
| 02 | replicateBE 1.1.3 rds01, EMA Annex II (2016) | Public reference endpoint data; clinical provenance not independently audited | Distributed by replicateBE under GPL >=3; original EMA attribution retained |
| 03 | rds05, Shumaker & Metzler (1998), Appendix | Published phenytoin Cmax endpoints | replicateBE GPL >=3 distribution; original publication attribution retained |
| 04 | rds28 | Source-package synthetic, homoscedastic | replicateBE GPL >=3 |
| 05 | rds23, FDA CDER Drug 7 | Public reference Cmax endpoints | replicateBE GPL >=3 distribution; FDA source attribution |
| 06 | rds24, FDA CDER Drug 1 | Public reference Cmax endpoints | replicateBE GPL >=3 distribution; FDA source attribution |
| 07 | rds03, rds01 with period 4 removed by replicateBE | Edited reference data, not a new observed 3-period study | replicateBE GPL >=3; EMA source attribution |
| 08 | rds10, Chow & Liu (2009), Table 9.3.3, p275 | Published AUC endpoints; nine subjects per sequence | replicateBE GPL >=3 distribution; book attribution |
| 09 | rds27 | Source-package synthetic, homoscedastic | replicateBE GPL >=3 |
| 10 | rds02, EMA Annex III (2016) | Public reference endpoints | replicateBE GPL >=3 distribution; EMA attribution |
| 11 | rds22 | Source-package synthetic, homoscedastic | replicateBE GPL >=3 |
| 12–14 | `simulate_design()` in data-raw/prepare_datasets.R | OpenBE synthetic | OpenBE AGPL-3 |
| NCA | R datasets::Theoph, Boeckmann, Sheiner & Beal (1994), NONMEM Users Guide Part V | Observed theophylline oral profiles, 12 subjects, 11 samples each | R datasets GPL >=2; original reference retained |

Package availability does not establish a separate clinical-data license. These
are attributed copies of the datasets as distributed by the named packages,
not a claim to relicense their original publications. Before redistributing a
clinical extract outside this software, confirm any additional source terms.
Original replicateBE dataset help (including sources and caveats) is accessible
with `help("refdata", package="replicateBE")` and `help("rds01", package="replicateBE")`.

## Synthetic model

Designs 12–14 use natural-log endpoints:

`log(PK_ij) = log(100) + treatment_effect + 0.02*(period-1) + b_i + e_ij`.

Independent `b_i ~ N(0, 0.3^2)` and `e_ij ~ N(0, 0.2^2)`. Treatment effects:
R=0, T=log(0.95), A=log(0.95), B=log(1.03), C=log(0.98). Endpoints have arbitrary
illustrative units. No dropout, BLQ or carryover is simulated. Allocation is
balanced deterministic sequence assignment for illustration, not a clinical
randomization list.

- Design 12: seed 12012, 30 subjects per group, one period. Both random terms
  contribute to between-subject variation (total log variance 0.13). Within-
  subject variance is not estimable from this parallel design.
- Design 13: seed 13013, six subjects per each of six sequences (36 total),
  three periods; within log variance 0.04 and between log variance 0.09.
- Design 14: seed 14014, eight subjects per each of four sequences (32 total),
  four periods, same variance components.

Historical package simulations retain their original values. Their original
seeds and full generation parameters are not supplied in the CRAN data help;
OpenBE does not invent them. Reproduction uses the pinned source data, not a
claim to regenerate those historical simulations.

## Theophylline NCA

Dose is subject-specific in mg/kg (approximately 4–6 mg/kg), time is hours and
concentration is mg/L. Sampling times vary by subject; all actual times and
doses are in `theoph.csv`. No observations are imputed. The wrapper rejects
missing observations and negative concentrations. Zero means BLQ under the
explicit PKNCA policy, not an inferred assay limit. The example retains measured
nonzero predose values; it does not subtract baseline automatically. This can
affect interpretation. Terminal-phase estimates and extrapolation must be
reviewed before use.

## References

Shumaker RC, Metzler CM. Drug Inf J. 1998;32:1063–1072. DOI:10.1177/009286159803200426.
Chow SC, Liu JP. Design and Analysis of Bioavailability and Bioequivalence Studies.
3rd ed. CRC Press; 2009.
Boeckmann AJ, Sheiner LB, Beal SL. NONMEM Users Guide, Part V. 1994.
