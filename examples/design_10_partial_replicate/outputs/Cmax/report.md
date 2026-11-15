# Analysis report

Method: Method A fixed effects / Method B random intercept
Degrees of freedom: A Residual; B Containment
Model: log(PK) ~ subject + period + treatment
Covariance: Common residual log variance
Analyzed observations: 72 of 72
Analyzed subjects: 24
Absent planned records: 0
Input SHA-256: 92e747ddabe7e7b69771d3ed9c36074c481d5db3f8d4c2a9d529cbff545a851a

## Estimates

```text
  method      gmr     lower    upper df     cv_wR cv_wT       swR abe_numeric
1      A 1.022644 0.9731555 1.074649 45 0.1117076    NA 0.1113615        TRUE
2      B 1.022644 0.9731555 1.074649 45 0.1117076    NA 0.1113615        TRUE
  abel_lower abel_upper abel_numeric
1        0.8       1.25         TRUE
2        0.8       1.25         TRUE
```

## Model diagnostics

```text
List of 10
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:13:37 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 72
  ..$ analyzed_rows       : int 72
  ..$ input_subjects      : int 24
  ..$ analyzed_subjects   : int 24
  ..$ retained_source_rows: int [1:72] 1 2 3 4 5 6 7 8 9 10 ...
  ..$ exclusions          :'data.frame':	0 obs. of  6 variables:
  .. ..$ subject   : int(0)
  .. ..$ sequence  : chr(0)
  .. ..$ period    : int(0)
  .. ..$ treatment : chr(0)
  .. ..$ source_row: int(0)
  .. ..$ reason    : chr(0)
  ..$ absent_records      :'data.frame':	0 obs. of  2 variables:
  .. ..$ subject: chr(0)
  .. ..$ period : int(0)
  ..$ missing_policy      : chr "omit"
  ..$ sequence_counts     :'data.frame':	3 obs. of  2 variables:
  .. ..$ Var1: Factor w/ 3 levels "RRT","RTR","TRR": 1 2 3
  .. ..$ Freq: int [1:3] 8 8 8
  ..$ input_sha256        : chr "92e747ddabe7e7b69771d3ed9c36074c481d5db3f8d4c2a9d529cbff545a851a"
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
  ..$ fixed_rank            : int 27
  ..$ fixed_columns         : int 27
  ..$ residual_sd           : num 0.118
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
  .. ..$ variance          : num [1:2] 0.0422 0.014
  .. ..$ standard_deviation: num [1:2] 0.205 0.118
  ..$ formula               : chr "log(PK) ~ sequence + period + treatment"
  ..$ fit_method            : chr "REML"
  ..$ fixed_rank            : int 6
  ..$ fixed_columns         : int 6
  ..$ residual_sd           : num 0.118
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
  ..$ gmr         : num 1.02
  ..$ lower       : num 0.973
  ..$ upper       : num 1.07
  ..$ df          : int 45
  ..$ cv_wR       : num 0.112
  ..$ cv_wT       : num NA
  ..$ swR         : num 0.111
  ..$ abe_numeric : logi TRUE
  ..$ abel_lower  : num 0.8
  ..$ abel_upper  : num 1.25
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
