# Analysis report

Method: Equal-variance parallel
Degrees of freedom:  Pooled N_T+N_R-2
Model: log(PK) ~ treatment
Covariance: Common between-subject log variance
Analyzed observations: 60 of 60
Analyzed subjects: 60
Absent planned records: 0
Input SHA-256: 69ac1bcf32e9863427986615c9b4600f8609d541918fd815bb7fc6bd6dd0d55d

## Estimates

```text
        gmr     lower     upper log_estimate        se df   p_lower
1 0.8300957 0.6971962 0.9883285   -0.1862143 0.1043785 58 0.3623852
       p_upper alpha abe_numeric
1 0.0001175106  0.05       FALSE
```

## Model diagnostics

```text
List of 9
 $ schema_version   : chr "1.0"
 $ created_utc      : chr "2026-11-15 22:13:48 UTC"
 $ population       :List of 10
  ..$ input_rows          : int 60
  ..$ analyzed_rows       : int 60
  ..$ input_subjects      : int 60
  ..$ analyzed_subjects   : int 60
  ..$ retained_source_rows: int [1:60] 1 2 3 4 5 6 7 8 9 10 ...
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
  .. ..$ Var1: Factor w/ 2 levels "R","T": 1 2
  .. ..$ Freq: int [1:2] 30 30
  ..$ input_sha256        : chr "69ac1bcf32e9863427986615c9b4600f8609d541918fd815bb7fc6bd6dd0d55d"
 $ engine_versions  :List of 2
  ..$ OpenBE: chr "0.1.1"
  ..$ stats : chr "4.5.0"
 $ method           : chr "Equal-variance parallel"
 $ df_method        : chr "Pooled N_T+N_R-2"
 $ covariance       : chr "Common between-subject log variance"
 $ model            :List of 13
  ..$ model_class           : chr "lm"
  ..$ variance_components   : NULL
  ..$ formula               : chr "log(PK) ~ treatment"
  ..$ fit_method            : chr "OLS"
  ..$ fixed_rank            : int 2
  ..$ fixed_columns         : int 2
  ..$ residual_sd           : num 0.404
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
  ..$ gmr         : num 0.83
  ..$ lower       : num 0.697
  ..$ upper       : num 0.988
  ..$ log_estimate: num -0.186
  ..$ se          : num 0.104
  ..$ df          : int 58
  ..$ p_lower     : num 0.362
  ..$ p_upper     : num 0.000118
  ..$ alpha       : num 0.05
  ..$ abe_numeric : logi FALSE
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
