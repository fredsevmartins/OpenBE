# Statistical models

All endpoint analyses use natural logarithms. Exponentiating a log-treatment
contrast gives a geometric ratio; intervals use t quantiles with the method's
reported DF. Estimates are not rounded before interval containment.

## Conventional crossover

BE 0.3.0 delegates to sasLM 1.0.1 for a SAS-style type III ANOVA with fixed
sequence, subject nested in sequence, period and treatment. Sequence is tested
against subject(sequence). Geometric LS means and T/R 90% CI come from BE. An
algebraically equivalent unique-subject fixed model supplies diagnostics and
TOST p-values. See the design 01 tutorial and independent difference-formula tests.

## Replicate crossover

replicateBE Method A uses fixed sequence, subject(sequence), period and treatment.
Separate R/T subsets yield treatment-specific within-subject variance where
replication and period structure permit estimation. Method B uses REML with
fixed sequence/period/treatment and a random subject intercept, **common residual
variance**, and option-specific DF: 2 nlme containment, 1 lmerTest Satterthwaite,
3 Kenward–Roger. It is not a heterogeneous covariance FDA RSABE implementation.
CV = sqrt(exp(s_w^2)−1). No automatic outlier deletion or alpha adjustment is
performed. Partial replicates return no identifiable CVwT.

## Custom OpenBE workflows

Parallel: equal-variance log-linear treatment model, independent subjects and
pooled residual variance (between-subject). Williams: complete 3/4-treatment
allocation, fixed sequence/period/treatment, random subject intercept and common
residual variance via nlme, adjusted means/contrasts via emmeans. The 90% CIs
are unadjusted; separate Holm-adjusted TOST p-values address a declared family.
All remain EXPERIMENTAL. Williams carryover balance is verified structurally;
absence of differential carryover remains a substantive model assumption.

## Missingness and estimability

No endpoint imputation. Conventional analysis requires complete pairs. Replicate
omission must be explicit (`missing="omit"`), warns for missing endpoint values
and leaves the missing-at-random/model assumptions for scientific review.
Absent rows are not detectable as missing endpoint cells; inspect the design
counts. Invalid labels, duplicate subject/period, mismatched sequence allocation,
nonpositive endpoints and insufficient DF are rejected. Custom Williams examples
are restricted to complete supported sequences.

## Scope of inference

Study design, estimand, variance structure and missingness policy must be defined
before selecting a method. Numerical interval containment and legacy ABEL limits
are separate from regulatory eligibility. See [regulatory framework](regulatory-framework.md)
and [scientific validation](validation/VALIDATION_REPORT.md).
