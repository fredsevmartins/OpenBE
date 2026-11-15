# Analysis report

Method: Method A fixed effects / Method B random intercept
Degrees of freedom: A Residual; B Containment
Model: log(PK) ~ subject + period + treatment
Covariance: Common residual log variance
Analyzed observations: 298 of 298
Analyzed subjects: 77
Absent planned records: 10
Input SHA-256: 793eef9d3840ee2f3653526a1773de635c6171c0df1b699eb0c752bc1f247a14

## Estimates

```text
  method      gmr    lower    upper  df     cv_wR     cv_wT       swR
1      A 1.156587 1.071057 1.248948 217 0.4696431 0.3515709 0.4464455
2      B 1.157298 1.071707 1.249725 217 0.4696431 0.3515709 0.4464455
  abe_numeric abel_lower abel_upper abel_numeric
1        TRUE  0.7122698   1.403962         TRUE
2        TRUE  0.7122698   1.403962         TRUE
```

## Model diagnostics

```text
List of 10
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:12:47 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 298
  ..$ analyzed_rows       : int 298
  ..$ input_subjects      : int 77
  ..$ analyzed_subjects   : int 77
  ..$ retained_source_rows: int [1:298] 1 2 3 4 5 6 7 8 9 10 ...
  ..$ exclusions          :'data.frame':	0 obs. of  6 variables:
  .. ..$ subject   : int(0)
  .. ..$ sequence  : chr(0)
  .. ..$ period    : int(0)
  .. ..$ treatment : chr(0)
  .. ..$ source_row: int(0)
  .. ..$ reason    : chr(0)
  ..$ absent_records      :'data.frame':	10 obs. of  2 variables:
  .. ..$ subject: chr [1:10] "11" "20" "24" "31" ...
  .. ..$ period : int [1:10] 3 3 2 3 3 3 4 3 3 4
  ..$ missing_policy      : chr "omit"
  ..$ sequence_counts     :'data.frame':	2 obs. of  2 variables:
  .. ..$ Var1: Factor w/ 2 levels "RTRT","TRTR": 1 2
  .. ..$ Freq: int [1:2] 38 39
  ..$ input_sha256        : chr "793eef9d3840ee2f3653526a1773de635c6171c0df1b699eb0c752bc1f247a14"
 $ engine_versions  :List of 5
  ..$ OpenBE     : chr "0.1.1"
  ..$ replicateBE: chr "1.1.3"
  ..$ nlme       : chr "3.1.168"
  ..$ lmerTest   : chr "3.1.3"
  ..$ lme4       : chr "1.1.37"
 $ method           : chr "Method A fixed effects / Method B random intercept"
 $ df_method        :List of 2
  ..$ A: chr "Residual"
  ..$ B: chr "Containment"
 $ covariance       : chr "Common residual log variance"
 $ model            :List of 13
  ..$ model_class           : chr "lm"
  ..$ variance_components   : NULL
  ..$ formula               : chr "log(PK) ~ subject + period + treatment"
  ..$ fit_method            : chr "OLS"
  ..$ fixed_rank            : int 81
  ..$ fixed_columns         : int 81
  ..$ residual_sd           : num 0.4
  ..$ optimizer_status      : chr "NOT_APPLICABLE"
  ..$ singular_random_effect: logi NA
  ..$ covariance_warning    : chr NA
  ..$ optimizer_messages    : NULL
  ..$ optimizer_codes       : NULL
  ..$ warnings              : chr(0)
 $ scientific_status: chr "Targeted numerical tests do not establish independent clinical qualification"
 $ method_B         :List of 14
  ..$ model_class           : chr "lme"
  ..$ variance_components   :'data.frame':	2 obs. of  3 variables:
  .. ..$ component         : chr [1:2] "(Intercept)" "Residual"
  .. ..$ variance          : num [1:2] 0.707 0.16
  .. ..$ standard_deviation: num [1:2] 0.841 0.4
  ..$ formula               : chr "log(PK) ~ sequence + period + treatment"
  ..$ fit_method            : chr "REML"
  ..$ fixed_rank            : int 6
  ..$ fixed_columns         : int 6
  ..$ residual_sd           : num 0.4
  ..$ optimizer_status      : chr "RETURNED_MODEL_REVIEW_WARNINGS"
  ..$ singular_random_effect: logi NA
  ..$ covariance_warning    : chr NA
  ..$ optimizer_messages    : NULL
  ..$ optimizer_codes       : NULL
  ..$ warnings              : chr(0)
  ..$ note                  : chr "Diagnostic refit using the same model specification; primary estimates remain engine outputs"
```

## Regulatory assessment

```text
List of 9
 $ classification: chr "REGULATORY_ASSESSMENT_NOT_DETERMINED"
 $ guideline     : chr NA
 $ endpoint      : chr NA
 $ statistics    :'data.frame':	1 obs. of  12 variables:
  ..$ method      : chr "A"
  ..$ gmr         : num 1.16
  ..$ lower       : num 1.07
  ..$ upper       : num 1.25
  ..$ df          : int 217
  ..$ cv_wR       : num 0.47
  ..$ cv_wT       : num 0.352
  ..$ swR         : num 0.446
  ..$ abe_numeric : logi TRUE
  ..$ abel_lower  : num 0.712
  ..$ abel_upper  : num 1.4
  ..$ abel_numeric: logi TRUE
 $ rule          : NULL
 $ eligibility   :List of 2
  ..$ determined: logi FALSE
  ..$ eligible  : logi NA
 $ limits        : NULL
 $ stages        :List of 5
  ..$ statistics    : chr "RECEIVED"
  ..$ rule_selection: chr "NOT_SELECTED"
  ..$ eligibility   : chr "NOT_DETERMINED"
  ..$ limits        : chr "NOT_DETERMINED"
  ..$ classification: chr "NOT_DETERMINED"
 $ reason        : chr "Select a qualified versioned rule and establish study-specific eligibility"
```

Targeted numerical tests do not establish independent clinical qualification
