# Analysis report

Method: Method A fixed effects / Method B random intercept
Degrees of freedom: A Residual; B Containment
Model: log(PK) ~ subject + period + treatment
Covariance: Common residual log variance
Analyzed observations: 156 of 160
Analyzed subjects: 39
Absent planned records: 0
Input SHA-256: c4ff91e02241715a098a84fdde97518ec2220ec669cf09707e7348a263c71d7f

## Estimates

```text
  method       gmr     lower    upper  df     cv_wR     cv_wT       swR
1      A 0.9789466 0.8723787 1.098533 113 0.5424018 0.3379685 0.5078312
2      B 0.9789466 0.8723787 1.098533 113 0.5424018 0.3379685 0.5078312
  abe_numeric abel_lower abel_upper abel_numeric
1        TRUE  0.6983678    1.43191         TRUE
2        TRUE  0.6983678    1.43191         TRUE
```

## Model diagnostics

```text
List of 10
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:13:11 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 160
  ..$ analyzed_rows       : int 156
  ..$ input_subjects      : int 40
  ..$ analyzed_subjects   : int 39
  ..$ retained_source_rows: int [1:156] 1 2 3 4 5 6 7 8 9 10 ...
  ..$ exclusions          :'data.frame':	4 obs. of  6 variables:
  .. ..$ subject   : int [1:4] 16 16 16 16
  .. ..$ sequence  : chr [1:4] "TRRT" "TRRT" "TRRT" "TRRT"
  .. ..$ period    : int [1:4] 1 2 3 4
  .. ..$ treatment : chr [1:4] "T" "R" "R" "T"
  .. ..$ source_row: int [1:4] 53 54 55 56
  .. ..$ reason    : chr [1:4] "Missing PK; explicit omission" "Missing PK; explicit omission" "Missing PK; explicit omission" "Missing PK; explicit omission"
  ..$ absent_records      :'data.frame':	0 obs. of  2 variables:
  .. ..$ subject: chr(0)
  .. ..$ period : int(0)
  ..$ missing_policy      : chr "omit"
  ..$ sequence_counts     :'data.frame':	4 obs. of  2 variables:
  .. ..$ Var1: Factor w/ 4 levels "RRTT","RTTR",..: 1 2 3 4
  .. ..$ Freq: int [1:4] 10 10 9 10
  ..$ input_sha256        : chr "c4ff91e02241715a098a84fdde97518ec2220ec669cf09707e7348a263c71d7f"
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
  ..$ fixed_rank            : int 43
  ..$ fixed_columns         : int 43
  ..$ residual_sd           : num 0.434
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
  .. ..$ variance          : num [1:2] 0.455 0.188
  .. ..$ standard_deviation: num [1:2] 0.674 0.434
  ..$ formula               : chr "log(PK) ~ sequence + period + treatment"
  ..$ fit_method            : chr "REML"
  ..$ fixed_rank            : int 8
  ..$ fixed_columns         : int 8
  ..$ residual_sd           : num 0.434
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
  ..$ gmr         : num 0.979
  ..$ lower       : num 0.872
  ..$ upper       : num 1.1
  ..$ df          : int 113
  ..$ cv_wR       : num 0.542
  ..$ cv_wT       : num 0.338
  ..$ swR         : num 0.508
  ..$ abe_numeric : logi TRUE
  ..$ abel_lower  : num 0.698
  ..$ abel_upper  : num 1.43
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
