# OpenBE development

- All repository documentation and code comments are English.
- Scientific correctness precedes breadth. Never invent reference values or claim regulatory endorsement.
- Keep computations, eligibility checks and regulatory conclusions separate. Unknown applicability returns `REGULATORY_ASSESSMENT_NOT_DETERMINED`.
- Check installed package signatures and source before using a new engine or study design.
- Every analytical example needs provenance, model assumptions, executable code, figures and a validation status.
- Do not classify a method as VALIDATED solely because its script or tests run. Describe the scope of numerical evidence.
- Preserve licenses and attribution, including PKNCA's AGPL-3 terms.
- Use the existing checkout. Cloud tasks are already isolated; do not create worktrees unless explicitly requested.
- Run `Rscript scripts/run_validation.R`, `Rscript scripts/run_all_examples.R` and `R CMD check` for scientific changes. Render tutorials for documentation changes.
- Do not merge automatically or claim remote CI/deployment succeeded without evidence.
