# Publication status

The complete scientific implementation is published on the default `main`
branch of https://github.com/fredsevmartins/OpenBE. Version 0.1.1 adds the
[scientific hardening improvements](HARDENING_0.1.1.md). It includes the R package,
source datasets, 14 design examples, results, figures, documentation, tests and
GitHub Actions workflows. Installation instructions use `main`.

The implementation was developed on `codex/initial-scientific-implementation`.
After the user explicitly authorized making all files visible on the main
repository page, `main` was advanced to the implementation with a fast-forward
update. The original commits remain in history; no force push was used.

## Pull request history

The earlier `gh pr create` attempt returned:

```text
Post "https://api.github.com/graphql": Forbidden
```

No PR was created. The user subsequently authorized direct publication to `main`,
so that earlier PR is no longer needed to make the implementation available.
The original proposed description is retained in [PULL_REQUEST.md](PULL_REQUEST.md)
as historical documentation. Git push success does not establish API access.

## CI and website

Local R CMD check, validation and documentation rendering passed. GitHub Actions
workflows have been pushed but their remote results have not been verified.
The Quarto site is built locally and deployment is configured for main; GitHub
Pages deployment has not been verified or claimed.

## Environment publication

Installation/start instructions, the implementation commit and required network
domains are saved in the environment draft. Review and save them in environment
settings, then publish the prepared environment. Saving a draft does not change
the current runtime's allowlist or establish a published snapshot. No new-task
restoration is claimed from the local separate-prefix bootstrap test.
