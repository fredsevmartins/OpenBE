# Regulatory framework and limits

OpenBE separates (1) statistical output, (2) rule selection, (3) eligibility,
(4) acceptance limits and (5) classification. The current release implements
statistics and transparent numerical conventional/legacy expanded limits.
It deliberately does **not** qualify a currently effective regulatory policy.
`regulatory_rules()` records version, source, effective-date and qualification
metadata. Every shipped rule remains unqualified, so default
`assess_regulatory()` calls return `REGULATORY_ASSESSMENT_NOT_DETERMINED`.
Custom registers are explicit caller attestations; they require source hashes,
verification dates, an effective window and endpoint/study eligibility before
numerical classification. Synthetic test registers are not official guidance. Engine-produced pass/fail text is
archived as historical engine output, not endorsed as a submission conclusion.

## Source-verification register

During this execution, official-source requests were blocked by the environment's
restricted network (CONNECT HTTP 403). Therefore **current effective status was
not verified**. Do not assume the 2010 EMA text or the 2016 Annex remains the
applicable rule following ICH M13A implementation. The following are authoritative
locations for the required follow-up audit, not evidence that their current
contents were retrieved:

- ICH M13A: https://www.ich.org/page/multidisciplinary-guidelines and https://database.ich.org/
- EMA M13A implementation: https://www.ema.europa.eu/en/ich-m13a-bioequivalence-immediate-release-solid-oral-dosage-forms-scientific-guideline
- EMA investigation of bioequivalence: https://www.ema.europa.eu/en/investigation-bioequivalence-scientific-guideline
- EMA clinical pharmacology/PK questions and answers: https://www.ema.europa.eu/en/human-regulatory-overview/research-development/scientific-guidelines/clinical-pharmacology-pharmacokinetics/clinical-pharmacology-pharmacokinetics-questions-answers
- FDA guidance database and product-specific guidance: https://www.fda.gov/drugs/guidances-drugs

## Historical computational rule

The replicateBE 1.1.3 implementation uses EMA-style widening above CVwR 30%,
`exp(+-0.760*s_wR)`, capped at CVwR 50%, plus a GMR restriction 0.80–1.25.
At or below 30%, conventional limits apply. OpenBE exposes this mathematical
rule as `abel_limits()` and labels results `abel_numeric`. This is not FDA
RSABE, not automatic ABEL eligibility, and not permission to widen AUC limits.
In particular, the AUC example in design 08 is not eligible merely because the
function can compute widened bounds. No outliers are removed automatically.

For conventional numerical containment, bounds are inclusive and evaluated
without rounding. At an exact CI boundary, the one-sided p-value can equal
alpha; distinguish the mathematical containment convention from strict
p<alpha and from a jurisdiction-specific reporting rule.

## Required before regulatory classification

A qualified implementation would need archived authoritative source text,
version and effective date; jurisdiction and application type; formulation,
strength, endpoint and study conditions; product-specific exceptions; eligible
replication and reliable reference variability; prespecified SAP, scaling and
outlier policy; and numerical qualification of the selected method. Narrow
therapeutic index, highly variable drugs, modified release, and multiple-dose
studies require specific consideration. The 2022 engine's historical decisions
cannot substitute for that audit. No software approval or regulatory endorsement
is claimed.

## Executable source-access and qualification audit

Run `Rscript scripts/audit_regulatory_sources.R` to record access outcomes and
hash any successfully retrieved source. Retrieval does not establish content,
version, scope or current applicability. The latest outcomes are in
[the source-access register](regulatory/source-access.csv). Five-stage gates,
caller-attestation limits and safe abstention are documented in the
[0.1.1 technical report](technical/HARDENING_0.1.1.md).
