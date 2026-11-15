# Study designs

Every design has a runnable R script and a rendered tutorial. Numerical evidence is in the [validation report](validation/VALIDATION_REPORT.md). None is globally classified VALIDATED.

| Design | Sequences | Periods | Engine | Analytical status | Validation status | Tutorial |
|---|---|---|---|---|---|---|
| 01 | TR / RT | 2 | BE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 01: 2x2 crossover](tutorials/design_01_2x2_crossover.qmd) |
| 02 | TRTR / RTRT | 4 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 02: full replicate TRTR RTRT](tutorials/design_02_full_replicate_TRTR_RTRT.qmd) |
| 03 | TRRT / RTTR | 4 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 03: full replicate TRRT RTTR](tutorials/design_03_full_replicate_TRRT_RTTR.qmd) |
| 04 | TTRR / RRTT | 4 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 04: full replicate TTRR RRTT](tutorials/design_04_full_replicate_TTRR_RRTT.qmd) |
| 05 | TRTR / RTRT / TRRT / RTTR | 4 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 05: four sequence replicate](tutorials/design_05_four_sequence_replicate.qmd) |
| 06 | TRRT / RTTR / TTRR / RRTT | 4 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 06: alternative four sequence replicate](tutorials/design_06_alternative_four_sequence_replicate.qmd) |
| 07 | TRT / RTR | 3 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 07: three period full replicate](tutorials/design_07_three_period_full_replicate.qmd) |
| 08 | TRR / RTT | 3 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 08: alternative three period replicate](tutorials/design_08_alternative_three_period_replicate.qmd) |
| 09 | TR / RT / TT / RR | 2 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 09: balaam](tutorials/design_09_balaam.qmd) |
| 10 | TRR / RTR / RRT | 3 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 10: partial replicate](tutorials/design_10_partial_replicate.qmd) |
| 11 | TRR / RTR | 3 | replicateBE | Research workflow | TESTED_NOT_INDEPENDENTLY_VALIDATED | [Design 11: extra reference](tutorials/design_11_extra_reference.qmd) |
| 12 | T / R | 1 | stats::lm (OpenBE) | Research workflow | EXPERIMENTAL | [Design 12: parallel](tutorials/design_12_parallel.qmd) |
| 13 | ABR / BRA / RAB / RBA / ARB / BAR | 3 | nlme + emmeans (OpenBE) | Research workflow | EXPERIMENTAL | [Design 13: williams three treatments](tutorials/design_13_williams_three_treatments.qmd) |
| 14 | ABCR / BRAC / RCBA / CARB | 4 | nlme + emmeans (OpenBE) | Research workflow | EXPERIMENTAL | [Design 14: williams four treatments](tutorials/design_14_williams_four_treatments.qmd) |
