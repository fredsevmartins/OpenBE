# Analysis report

Method: Conventional 2x2
Degrees of freedom:  Residual N-2
Model: log(PK) ~ subject + period + treatment
Covariance: Common residual log variance
Analyzed observations: 66 of 66
Analyzed subjects: 33
Absent planned records: 0
Input SHA-256: 52efb5f218505469d4a0be19eadacd2d53999c2bb33e9e97738873c8c13e83d4

## Estimates

```text
        gmr    lower    upper log_estimate         se df      p_lower
1 0.9540753 0.889436 1.023412  -0.04701267 0.04137675 31 8.904492e-05
       p_upper alpha abe_numeric
1 1.374095e-07  0.05        TRUE
```

## Model diagnostics

```text
List of 9
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:12:42 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 66
  ..$ analyzed_rows       : int 66
  ..$ input_subjects      : int 33
  ..$ analyzed_subjects   : int 33
  ..$ retained_source_rows: int [1:66] 1 2 3 4 5 6 7 8 9 10 ...
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
  ..$ sequence_counts     :'data.frame':	2 obs. of  2 variables:
  .. ..$ Var1: Factor w/ 2 levels "RT","TR": 1 2
  .. ..$ Freq: int [1:2] 17 16
  ..$ input_sha256        : chr "52efb5f218505469d4a0be19eadacd2d53999c2bb33e9e97738873c8c13e83d4"
 $ engine_versions  :List of 2
  ..$ OpenBE: chr "0.1.1"
  ..$ BE    : chr "0.3.0"
 $ method           : chr "Conventional 2x2"
 $ df_method        : chr "Residual N-2"
 $ covariance       : chr "Common residual log variance"
 $ model            :List of 13
  ..$ model_class           : chr "lm"
  ..$ variance_components   : NULL
  ..$ formula               : chr "log(PK) ~ subject + period + treatment"
  ..$ fit_method            : chr "OLS"
  ..$ fixed_rank            : int 35
  ..$ fixed_columns         : int 35
  ..$ residual_sd           : num 0.168
  ..$ optimizer_status      : chr "NOT_APPLICABLE"
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
 $ statistics    :'data.frame':	1 obs. of  10 variables:
  ..$ gmr         : num 0.954
  ..$ lower       : num 0.889
  ..$ upper       : num 1.02
  ..$ log_estimate: num -0.047
  ..$ se          : num 0.0414
  ..$ df          : int 31
  ..$ p_lower     : num 8.9e-05
  ..$ p_upper     : num 1.37e-07
  ..$ alpha       : num 0.05
  ..$ abe_numeric : logi TRUE
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
