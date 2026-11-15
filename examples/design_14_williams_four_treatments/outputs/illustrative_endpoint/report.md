# Analysis report

Method: Williams random-intercept
Degrees of freedom:  Containment; unadjusted intervals, separate Holm TOST
Model: log(PK) ~ sequence + period + treatment
Covariance: Common residual log variance
Analyzed observations: 128 of 128
Analyzed subjects: 32
Absent planned records: 0
Input SHA-256: c1f9d6a1acec9133a66c0432bf945a3115dee11babe03bada088fe7483d2bfa8

## Estimates

```text
  comparison       gmr     lower    upper log_estimate         se df
1      A - R 0.9880899 0.9021619 1.082202  -0.01198157 0.05474236 90
2      B - R 1.0480381 0.9568968 1.147860   0.04691992 0.05474236 90
3      C - R 1.0559055 0.9640801 1.156477   0.05439874 0.05474236 90
       p_lower      p_upper alpha  p_tost_holm abe_numeric
1 1.075252e-04 2.200573e-05  0.05 0.0003225755        TRUE
2 1.840218e-06 8.943631e-04  0.05 0.0017887262        TRUE
3 1.057220e-06 1.362157e-03  0.05 0.0017887262        TRUE
```

## Model diagnostics

```text
List of 9
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:13:58 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 128
  ..$ analyzed_rows       : int 128
  ..$ input_subjects      : int 32
  ..$ analyzed_subjects   : int 32
  ..$ retained_source_rows: int [1:128] 1 2 3 4 5 6 7 8 9 10 ...
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
  ..$ missing_policy      : chr "error"
  ..$ sequence_counts     :'data.frame':	4 obs. of  2 variables:
  .. ..$ Var1: Factor w/ 4 levels "ABCR","BRAC",..: 1 2 3 4
  .. ..$ Freq: int [1:4] 8 8 8 8
  ..$ input_sha256        : chr "c1f9d6a1acec9133a66c0432bf945a3115dee11babe03bada088fe7483d2bfa8"
 $ engine_versions  :List of 3
  ..$ OpenBE : chr "0.1.1"
  ..$ nlme   : chr "3.1.168"
  ..$ emmeans: chr "1.10.7"
 $ method           : chr "Williams random-intercept"
 $ df_method        : chr "Containment; unadjusted intervals, separate Holm TOST"
 $ covariance       : chr "Common residual log variance"
 $ model            :List of 13
  ..$ model_class           : chr "lme"
  ..$ variance_components   :'data.frame':	2 obs. of  3 variables:
  .. ..$ component         : chr [1:2] "(Intercept)" "Residual"
  .. ..$ variance          : num [1:2] 0.0457 0.0479
  .. ..$ standard_deviation: num [1:2] 0.214 0.219
  ..$ formula               : chr "log(PK) ~ sequence + period + treatment"
  ..$ fit_method            : chr "REML"
  ..$ fixed_rank            : int 10
  ..$ fixed_columns         : int 10
  ..$ residual_sd           : num 0.219
  ..$ optimizer_status      : chr "RETURNED_MODEL_REVIEW_WARNINGS"
  ..$ singular_random_effect: logi NA
  ..$ covariance_warning    : chr NA
  ..$ optimizer_messages    : NULL
  ..$ optimizer_codes       : NULL
  ..$ warnings              : chr(0)
 $ scientific_status: chr "Targeted numerical tests do not establish independent clinical qualification"
```

## Regulatory assessment

```text
List of 9
 $ classification: chr "REGULATORY_ASSESSMENT_NOT_DETERMINED"
 $ guideline     : chr NA
 $ endpoint      : chr NA
 $ statistics    :'data.frame':	3 obs. of  12 variables:
  ..$ comparison  : chr [1:3] "A - R" "B - R" "C - R"
  ..$ gmr         : num [1:3] 0.988 1.048 1.056
  ..$ lower       : num [1:3] 0.902 0.957 0.964
  ..$ upper       : num [1:3] 1.08 1.15 1.16
  ..$ log_estimate: num [1:3] -0.012 0.0469 0.0544
  ..$ se          : num [1:3] 0.0547 0.0547 0.0547
  ..$ df          : num [1:3] 90 90 90
  ..$ p_lower     : num [1:3] 1.08e-04 1.84e-06 1.06e-06
  ..$ p_upper     : num [1:3] 0.000022 0.000894 0.001362
  ..$ alpha       : num [1:3] 0.05 0.05 0.05
  ..$ p_tost_holm : num [1:3] 0.000323 0.001789 0.001789
  ..$ abe_numeric : logi [1:3] TRUE TRUE TRUE
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
