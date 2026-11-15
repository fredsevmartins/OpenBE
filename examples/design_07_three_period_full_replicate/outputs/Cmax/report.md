# Analysis report

Method: Method A fixed effects / Method B random intercept
Degrees of freedom: A Residual; B Containment
Model: log(PK) ~ subject + period + treatment
Covariance: Common residual log variance
Analyzed observations: 223 of 223
Analyzed subjects: 77
Absent planned records: 8
Input SHA-256: 6053b4dbacecf2f5a1558abf20af29c0cf2f7f84e3600cdbc24b9516b17e89ab

## Estimates

```text
  method      gmr    lower    upper  df     cv_wR     cv_wT       swR
1      A 1.241885 1.130492 1.364254 143 0.5834494 0.3018975 0.5412744
2      B 1.244734 1.133136 1.367324 143 0.5834494 0.3018975 0.5412744
  abe_numeric abel_lower abel_upper abel_numeric
1       FALSE  0.6983678    1.43191         TRUE
2       FALSE  0.6983678    1.43191         TRUE
```

## Model diagnostics

```text
List of 10
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:13:17 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 223
  ..$ analyzed_rows       : int 223
  ..$ input_subjects      : int 77
  ..$ analyzed_subjects   : int 77
  ..$ retained_source_rows: int [1:223] 1 2 3 4 5 6 7 8 9 10 ...
  ..$ exclusions          :'data.frame':	0 obs. of  6 variables:
  .. ..$ subject   : int(0)
  .. ..$ sequence  : chr(0)
  .. ..$ period    : int(0)
  .. ..$ treatment : chr(0)
  .. ..$ source_row: int(0)
  .. ..$ reason    : chr(0)
  ..$ absent_records      :'data.frame':	8 obs. of  2 variables:
  .. ..$ subject: chr [1:8] "11" "20" "24" "31" ...
  .. ..$ period : int [1:8] 3 3 2 3 3 3 3 3
  ..$ missing_policy      : chr "omit"
  ..$ sequence_counts     :'data.frame':	2 obs. of  2 variables:
  .. ..$ Var1: Factor w/ 2 levels "RTR","TRT": 1 2
  .. ..$ Freq: int [1:2] 38 39
  ..$ input_sha256        : chr "6053b4dbacecf2f5a1558abf20af29c0cf2f7f84e3600cdbc24b9516b17e89ab"
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
  ..$ fixed_rank            : int 80
  ..$ fixed_columns         : int 80
  ..$ residual_sd           : num 0.399
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
  .. ..$ variance          : num [1:2] 0.714 0.159
  .. ..$ standard_deviation: num [1:2] 0.845 0.399
  ..$ formula               : chr "log(PK) ~ sequence + period + treatment"
  ..$ fit_method            : chr "REML"
  ..$ fixed_rank            : int 5
  ..$ fixed_columns         : int 5
  ..$ residual_sd           : num 0.399
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
  ..$ gmr         : num 1.24
  ..$ lower       : num 1.13
  ..$ upper       : num 1.36
  ..$ df          : int 143
  ..$ cv_wR       : num 0.583
  ..$ cv_wT       : num 0.302
  ..$ swR         : num 0.541
  ..$ abe_numeric : logi FALSE
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
