# Scientific validation report

Scope: research implementation and targeted numerical verification, not a blanket software/regulatory qualification.

This invocation executed 13 test blocks and 158 passing expectations; failures=0, errors=0, skipped=0.
All 84 recorded numerical comparisons passed their explicit absolute tolerances.

## Evidence

- [Test outcome counts](test-summary.csv), [machine-readable test results](test-results.rds), [session information](sessionInfo.txt).
- [Expected/observed/difference/tolerance/source per numerical check](numerical-comparisons.csv).
- [Per-design completion and validation status](design-status.csv).
- [SHA-256 input fingerprints](dataset-sha256.csv).

## Interpretation and limitations

Design 01: BE estimates, both endpoints, CV, TOST p-values and DF agree with independent closed-form sequence-stratified subject differences. This is targeted analytical verification on the supplied simulated data, not comprehensive clinical validation.

Designs 02–11: Method A GMR, CI and DF agree with an independent subject-centered normal-equation implementation on each design's reference data. Separate within-treatment variance estimates are checked in the test suite using projected residual sums of squares. This supports the selected calculations, not every missingness/covariance/outlier pattern.

Method B: EMA rds01 rounded package example values are reproduced to half the last printed percentage digit. This is shared-engine/reference-example corroboration, not an independent reference implementation. Option 2 is cross-checked against nlme; options 1 and 3 execute and return finite contrasts but do not yet have external DF reference values for every design.

Design 12: independent pooled-t algebra corroborates the equal-variance parallel model. Designs 13–14: balanced random-intercept contrasts match fixed-subject normal equations; period and first-order carryover balance are tested. These custom workflows remain EXPERIMENTAL pending broader external reference qualification, missing-data studies and covariance sensitivity.

NCA: a separately labeled analytical exponential profile checks Cmax, Tmax, AUClast, AUCinf, lambda.z, half-life and extrapolated AUC percentage. A synthetic repeat-dose interval verifies tau integration. The observed Theoph example is a demonstration, not a complete validation of automated terminal-phase selection or clinical BLQ policy.

Planning: conventional output is cross-checked with power.TOST; scaled output is reproducible with the stated seed but is Monte Carlo and not independently qualified.

Boundary tests cover CI touching/outside conventional limits, scaling onset/cap, invalid labels, nonpositive endpoints, missing observations, unequal sequence sizes, insufficient DF and nonestimability. No assertions are disabled and no zero-test run is accepted.

## Classification

No complete analytical implementation is labeled VALIDATED. Designs 01–11 are TESTED_NOT_INDEPENDENTLY_VALIDATED; 12–14 are EXPERIMENTAL. FAIL is an individual numerical check outcome; FAILED is reserved for an implementation failing its required checks. NOT_IMPLEMENTED is used for unimplemented regulatory qualification (current rule selection/eligibility) and FDA RSABE. A script running successfully does not upgrade these statuses.

## Regulatory and publication limits

Current official guidance retrieval was blocked by network policy. All OpenBE regulatory classifications remain REGULATORY_ASSESSMENT_NOT_DETERMINED. Numerical ABE/legacy ABEL flags must not be interpreted as current regulatory eligibility. Local tests and rendering do not establish remote GitHub Actions success or GitHub Pages deployment.
