# Analysis report

Method: Williams random-intercept
Degrees of freedom:  Containment; unadjusted intervals, separate Holm TOST
Model: log(PK) ~ sequence + period + treatment
Covariance: Common residual log variance
Analyzed observations: 108 of 108
Analyzed subjects: 36
Absent planned records: 0
Input SHA-256: 62837cae966dc945f0782902299d48b31823a09904aac0a7e1209810aef4ae12

## Estimates

```text
  comparison       gmr     lower    upper log_estimate        se df
1      A - R 0.9875636 0.9160845 1.064620  -0.01251437 0.0450549 68
2      B - R 1.0334413 0.9586416 1.114077   0.03289431 0.0450549 68
       p_lower      p_upper alpha  p_tost_holm abe_numeric
1 7.200071e-06 8.853679e-07  0.05 1.440014e-05        TRUE
2 1.509513e-07 3.669970e-05  0.05 3.669970e-05        TRUE
```

## Model diagnostics

```text
List of 9
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:13:53 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 108
  ..$ analyzed_rows       : int 108
  ..$ input_subjects      : int 36
  ..$ analyzed_subjects   : int 36
  ..$ retained_source_rows: int [1:108] 1 2 3 4 5 6 7 8 9 10 ...
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
  ..$ sequence_counts     :'data.frame':	6 obs. of  2 variables:
  .. ..$ Var1: Factor w/ 6 levels "ABR","ARB","BAR",..: 1 2 3 4 5 6
  .. ..$ Freq: int [1:6] 6 6 6 6 6 6
  ..$ input_sha256        : chr "62837cae966dc945f0782902299d48b31823a09904aac0a7e1209810aef4ae12"
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
  .. ..$ variance          : num [1:2] 0.113 0.0365
  .. ..$ standard_deviation: num [1:2] 0.336 0.191
  ..$ formula               : chr "log(PK) ~ sequence + period + treatment"
  ..$ fit_method            : chr "REML"
  ..$ fixed_rank            : int 10
  ..$ fixed_columns         : int 10
  ..$ residual_sd           : num 0.191
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
 $ statistics    :'data.frame':	2 obs. of  12 variables:
  ..$ comparison  : chr [1:2] "A - R" "B - R"
  ..$ gmr         : num [1:2] 0.988 1.033
  ..$ lower       : num [1:2] 0.916 0.959
  ..$ upper       : num [1:2] 1.06 1.11
  ..$ log_estimate: num [1:2] -0.0125 0.0329
  ..$ se          : num [1:2] 0.0451 0.0451
  ..$ df          : num [1:2] 68 68
  ..$ p_lower     : num [1:2] 7.20e-06 1.51e-07
  ..$ p_upper     : num [1:2] 8.85e-07 3.67e-05
  ..$ alpha       : num [1:2] 0.05 0.05
  ..$ p_tost_holm : num [1:2] 1.44e-05 3.67e-05
  ..$ abe_numeric : logi [1:2] TRUE TRUE
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
