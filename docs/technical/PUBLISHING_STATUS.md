# Publication status

The following branches were successfully pushed to the existing repository:

- `main`: initial project-governance baseline only (the remote was initially empty).
- `codex/initial-scientific-implementation`: completed research implementation,
  examples, numerical evidence, figures, tutorials and CI configuration.

Repository: https://github.com/fredsevmartins/OpenBE

No merge has been performed.

## Pull request blocker

The actual `gh pr create` attempt returned:

```text
Post "https://api.github.com/graphql": Forbidden
```

Independent CONNECT attempts to api.github.com also returned HTTP 403 under
the current enforced network policy. Consequently **no pull request URL is
available and no PR creation is claimed**. Git access/push success does not
establish GitHub API authentication; the 403 prevents an authentication diagnosis.
No new token or credential value has been requested.

The completed PR title/body is preserved in [PULL_REQUEST.md](PULL_REQUEST.md).
After API access is available, create the PR without modifying the implementation:

```sh
gh pr create --repo fredsevmartins/OpenBE --base main \
  --head codex/initial-scientific-implementation \
  --title 'Implement reproducible OpenBE scientific workflows and validation' \
  --body-file docs/technical/PULL_REQUEST.md
```

Alternatively, the following is a **comparison/create-PR page, not an existing PR**:
https://github.com/fredsevmartins/OpenBE/compare/main...codex/initial-scientific-implementation?expand=1

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
