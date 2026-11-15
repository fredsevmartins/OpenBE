# Getting started

Requires R >=4.1. Tested here with R 4.5.0. Install released CRAN dependencies
and OpenBE from the development branch until the initial PR is merged:

```r
install.packages("remotes")
remotes::install_github("fredsevmartins/OpenBE", ref="codex/initial-scientific-implementation")
library(OpenBE)
result <- analyze_2x2(example_dataset(1, "AUClast"))
result$summary
result$regulatory$classification
```

For development, clone the same repository, check out the development branch
and run from its root:

```sh
Rscript scripts/install_dependencies.R
R CMD INSTALL .
Rscript examples/design_01_2x2_crossover/analysis.R
Rscript scripts/run_all_examples.R
Rscript scripts/run_validation.R
R CMD build .
R CMD check --no-manual OpenBE_0.1.0.tar.gz
Rscript scripts/build_documentation.R
```

Quarto CLI is required separately (implementation run: 1.8.27); the R quarto
package alone is insufficient. No Shiny server or credentials are needed for
local calculations. No worktree is needed: a cloud task is already isolated.

The lockfile records exact R package versions. `renv::restore()` installs into a
project library; `scripts/install_dependencies.R` uses that lock by default.
System libraries and Quarto CLI are not installed by renv. On Debian/Ubuntu,
install R and standard compilation/font/image/XML/curl/SSL dependencies before
restoring packages. See `scripts/setup_cloud.sh` for the tested local cloud
bootstrap, which requires no root privileges on Debian 13.

Each example writes CSV results, figures at 300 dpi and vector PDF, an RDS
analysis bundle and session information in predictable `examples/.../outputs/`
locations. Regeneration overwrites those generated outputs. Original source
CSV data remain in `inst/extdata/`. Documentation is English only.
