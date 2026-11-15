# Cloud environment readiness

The `cloud-environment-onboarding:setup` workflow was applied alongside the
user's explicit scientific implementation request. Existing application files
were initially absent. Implementation changes were authorized by that request;
setup commands preserve source, manifests and lockfiles.

## Verified locally

- Debian 13, R 4.5.0, Quarto CLI 1.8.27; scientific/documentation packages in
  `package-versions.csv` and `renv.lock`.
- Non-root installation under `/workspace/toolchain`, with signed Debian index
  and archive verification and published Quarto SHA-256 verification.
- `bash scripts/setup_cloud.sh` succeeds repeatedly in the prepared prefix.
- The same bootstrap succeeds in a separate initially empty
  `/workspace/bootstrap-verification` prefix, reusing verified Debian download
  archives but extracting and installing packages separately. Scientific source
  checkouts are at immutable audited commits. Its conventional, replicate and
  planning functional requests succeeded. This is a local clean-prefix test,
  not evidence of a new cloud task being restored.
- All 14 examples plus NCA/planning execute. Unit tests and numerical evidence
  are in the scientific validation report.
- Quarto rendered 14 design tutorials, NCA and planning, plus documentation pages.
  All 95 PNGs contain 300 dpi metadata (allowing storage rounding), with 95 PDF
  vector counterparts. A local HTML traversal found no missing local links or
  image resources in the initial 28-page rendered site.
- R CMD check --no-manual: Status OK.

## Dependencies, data and network

There are no required services, GUI sessions or database processes for this
workflow, and no new credentials are needed for local science. Restarted tasks
must activate the toolchain PATH, not assume a process survives publication.
Dependency source checkouts under audit/toolchain/bootstrap paths are build
caches, not additional OpenBE projects or forks.

Direct CRAN, EMA and GitHub API HTTPS CONNECT attempts returned HTTP 403 under
the enforced allowlist. CRAN package sources were audited and installed through
pinned CRAN GitHub mirrors. The normal full `renv::restore()` route is provided
for unrestricted/appropriately allowed networks, but was not independently
executed from an empty CRAN-backed library in this restricted runtime. The
separate-prefix bootstrap is the tested installation fallback.

Current official regulatory applicability is consequently unqualified. Git read
and push permissions and API/PR creation are separate operations; successful Git
access must not be described as verified API authentication. The API 403 blocks
an authentication diagnosis, so no additional token has been requested.

## Reusable configuration and publication

Reusable installation/start instructions and required scientific/API domains
are saved through the environment draft tool. Draft persistence does not apply
network changes to this runtime or publish a snapshot. Review and save those
changes in environment settings, then publish the prepared environment.
No fresh-task restoration, remote GitHub Actions result or GitHub Pages
deployment is claimed merely from local tests or configuration saving.
