# API reference

The installed R help is authoritative: `help(package='OpenBE')`.
All public functions are documented. Generated from the same Rd files using `Rscript scripts/generate_api_reference.R`.

## abel_limits

```text
Historical EMA-style expanded limits for computational exploration

Description:

     Uses k=0.760, widening only above CVwR=0.30, capped at CVwR=0.50.
     These historical constants are not a statement of current
     eligibility.

Usage:

     abel_limits(cv_wr)
     
Arguments:

   cv_wr: Single reference within-subject CV as a fraction.

Value:

     Lower and upper ratio limits.

```

## analyze_2x2

```text
Conventional two-sequence two-period bioequivalence

Description:

     Uses BE::test2x2 for the primary ANOVA, geometric LS means and
     ratio CI. A fixed-subject model supplies residual diagnostics and
     explicit TOST p-values. Complete subjects are required; sequence
     sizes may differ. No carryover term is fitted. Natural logarithms
     and a two-sided 90 percent CI are used.

Usage:

     analyze_2x2(data)
     
Arguments:

    data: Endpoint data accepted by validate_endpoints().

Value:

     List with summary, engine output, model, ANOVA, geometric LS
     means, within-subject CV (fraction), and undetermined regulatory
     assessment.

Examples:

     result <- analyze_2x2(example_dataset(1, "AUClast"))
     result$summary
     
```

## analyze_nca

```text
Noncompartmental analysis with PKNCA

Description:

     Explicit interval selection and options are required. Zeros are
     BLQ under PKNCA's rules; negative concentrations, duplicate times,
     missing observations and undeclared units are rejected here. A
     validated study-specific BLQ/missing policy must be applied
     upstream. No endpoint data are turned into profiles.

Usage:

     analyze_nca(
       concentration,
       dose,
       intervals,
       concentration_unit,
       time_unit,
       dose_unit,
       options = list(auc.method = "lin up/log down")
     )
     
Arguments:

concentration: Data frame with subject, time and concentration.

    dose: Data frame with subject, time and dose, with positive doses.

intervals: PKNCA interval specification with start, end and parameter
          flags.

concentration_unit, time_unit, dose_unit: Nonempty unit labels.

 options: Named options for PKNCAdata (for example auc.method).

Value:

     PKNCAresults object with unit labels attached as metadata.

```

## analyze_parallel

```text
Experimental equal-variance parallel-group analysis

Description:

     Fits log(PK) ~ treatment to independent subjects. Assumes a common
     between-subject log variance; this is not a Welch analysis.

Usage:

     analyze_parallel(data)
     
Arguments:

    data: Endpoint data; one period and one observation per subject.

Value:

     Model, ratio summary, between-subject CV and regulatory status.

```

## analyze_replicate

```text
Replicate bioequivalence using Methods A and B

Description:

     Delegates to replicateBE 1.1.3. Method A uses all fixed effects;
     Method B assumes a common residual variance and a random subject
     intercept (REML). Treatment-specific CVs are estimated in separate
     fixed-effect subset models. The engine's historical EMA ABEL
     classifications are retained as raw output only; they are not an
     OpenBE regulatory conclusion.

Usage:

     analyze_replicate(data, missing = c("error", "omit"), option = 2)
     
Arguments:

    data: Endpoint-level replicate study data.

 missing: "error" or explicit "omit"; no imputation is performed.

  option: Method B DF: 2 containment (nlme), 1 Satterthwaite
          (lmerTest), or 3 Kenward-Roger (lmerTest/pbkrtest).

Value:

     List with method comparison, raw engine outputs, diagnostics
     model, data and regulatory status. CVs in the comparison are
     fractions.

```

## analyze_williams

```text
Experimental Williams crossover analysis

Description:

     Fits a REML random-intercept model, with sequence, period and
     treatment fixed. Contrasts are each test minus R on the log scale
     using emmeans and nlme's containment DF. Reported 90 percent
     intervals are unadjusted; a separate Holm adjustment is supplied
     for the family of TOST p-values. Neither adjustment creates a
     regulatory claim. No differential carryover is modeled.

Usage:

     analyze_williams(data)
     
Arguments:

    data: Endpoint data, treatments encoded R, A, B (and C).

Value:

     Mixed model, unadjusted contrasts, geometric marginal means and
     status.

```

## assess_regulatory

```text
Separate regulatory applicability from statistical calculations

Description:

     No currently effective jurisdiction-specific policy has been
     qualified for this release. Always returns undetermined, retaining
     the supplied context and reason. Use numeric_abe() and
     abel_limits() for transparent calculations.

Usage:

     assess_regulatory(
       statistics,
       guideline = NA_character_,
       endpoint = NA_character_
     )
     
Arguments:

statistics: Statistical summary retained for traceability.

guideline: Guideline source and version, if supplied.

endpoint: Endpoint name, if known.

Value:

     A list with classification, guideline, endpoint and reason.

```

## example_dataset

```text
Load a packaged demonstration dataset

Description:

     Load a packaged demonstration dataset

Usage:

     example_dataset(design = 1, endpoint = c("AUClast", "Cmax"))
     
Arguments:

  design: Integer study design from 1 to 14.

endpoint: For design 1, AUClast or Cmax.

Value:

     Data frame. See inst/extdata/PROVENANCE.md before interpretation.

```

## numeric_abe

```text
Numerical conventional ABE interval containment

Description:

     Numerical conventional ABE interval containment

Usage:

     numeric_abe(lower, upper, limits = c(0.8, 1.25))
     
Arguments:

lower, upper: Ratio confidence limits, unrounded.

  limits: Two positive acceptance bounds.

Value:

     Logical values. Touching a bound is included; no rounding is
     applied.  This calculation does not assess regulatory
     applicability.

```

## numeric_abel

```text
Numerical historical ABEL calculation with the GMR constraint

Description:

     Numerical historical ABEL calculation with the GMR constraint

Usage:

     numeric_abel(lower, upper, gmr, cv_wr)
     
Arguments:

lower, upper: Single ratio confidence limits.

     gmr: Single Test/Reference ratio, contained within its confidence
          limits.

   cv_wr: Reference within-subject CV (fraction).

Value:

     Single logical result; no regulatory eligibility is inferred.

```

## plan_be

```text
Conventional and replicate study planning

Description:

     Wraps PowerTOST sampleN.TOST or sampleN.scABEL; design names must
     be supported by the selected engine. Planning support does not
     imply analysis support. Reference-scaled planning uses historical
     engine rules, not regulatory approval.

Usage:

     plan_be(
       cv = 0.2,
       ratio = 0.95,
       power = 0.8,
       design = "2x2",
       scaled = FALSE,
       seed = 20261115,
       nsims = 10000
     )
     
Arguments:

      cv: Assumed within-subject CV (fraction).

   ratio: Expected Test/Reference geometric mean ratio.

   power: Target power between zero and one.

  design: PowerTOST design name (for example 2x2 or 2x2x4).

  scaled: Use reference-scaled simulation planning.

    seed: Fixed seed used for simulation planning.

   nsims: Number of simulations for scaled planning.

Value:

     PowerTOST sample-size results.

```

## plot_analysis

```text
Generate reproducible scientific design and analysis figures

Description:

     Writes PNG at 300 dpi and vector PDF. Endpoint-only data do not
     yield concentration-time profiles. Replicate figures compare
     Methods A and B and show the historical scaling curve, explicitly
     as a numerical illustration.

Usage:

     plot_analysis(result, directory, title, provenance, script)
     
Arguments:

  result: Analysis result from an OpenBE analysis function.

directory: Output directory.

   title: Informative study title.

provenance: Source description and observed/simulated classification.

  script: Relative path of the generating script.

Value:

     Character vector of generated filenames, invisibly.

```

## validate_endpoints

```text
Validate endpoint-level study data

Description:

     Check unique subject-period records, positive endpoints, sequence
     consistency and treatment allocation. Missing endpoints are
     rejected by default and may be omitted explicitly without
     imputation. Subject IDs must be globally unique.

Usage:

     validate_endpoints(
       data,
       treatments = c("R", "T"),
       missing = c("error", "omit")
     )
     
Arguments:

    data: Data frame with subject, sequence, period, treatment and PK
          columns.

treatments: Allowed treatment labels, reference first.

 missing: Either "error" or "omit".

Value:

     A data frame with factor design columns and numeric PK.

```

## write_analysis

```text
Write a traceable analysis bundle

Description:

     Write a traceable analysis bundle

Usage:

     write_analysis(result, directory)
     
Arguments:

  result: OpenBE analysis result.

directory: Output directory.

Value:

     Output directory, invisibly.

```

